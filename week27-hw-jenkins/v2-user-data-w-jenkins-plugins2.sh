#!/bin/bash
set -euxo pipefail

# --------------------------------------
# System update
# --------------------------------------
sudo dnf update -y

# --------------------------------------
# Add 4GB swap (extra stability improvement beyond class requirement)
# --------------------------------------
if [ ! -f /swapfile ]; then
  sudo fallocate -l 4G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
fi

sudo swapon /swapfile || true

grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# --------------------------------------
# Increase /tmp to 4G if /tmp is tmpfs
# --------------------------------------
df -h /tmp
mount | grep /tmp || true

if mount | grep -q 'on /tmp type tmpfs'; then
  sudo mount -o remount,size=4G /tmp || true
fi

# --------------------------------------
# Install base dependencies
# Amazon Linux 2023: avoid installing full curl to prevent curl-minimal conflicts
# --------------------------------------
sudo dnf install -y wget git fontconfig java-21-amazon-corretto python3 dnf-plugins-core

# --------------------------------------
# Install AWS CLI
# --------------------------------------
sudo dnf install -y awscli

# --------------------------------------
# Install Terraform CLI
# --------------------------------------
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf install -y terraform

echo "===== TERRAFORM ====="
terraform version || true

# --------------------------------------
# Add Jenkins repo and key
# --------------------------------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

# --------------------------------------
# Install Jenkins
# --------------------------------------
sudo dnf install -y jenkins

# --------------------------------------
# Force Jenkins to use the Corretto 21 Java path
# --------------------------------------
sudo mkdir -p /etc/systemd/system/jenkins.service.d
sudo tee /etc/systemd/system/jenkins.service.d/override.conf > /dev/null <<'EOF'
[Service]
Environment="JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64"
Environment="JENKINS_JAVA_CMD=/usr/lib/jvm/java-21-amazon-corretto.x86_64/bin/java"
EOF

sudo systemctl daemon-reload

# --------------------------------------
# Prepare plugin install directories
# --------------------------------------
sudo mkdir -p /opt/jenkins-setup
sudo mkdir -p /var/lib/jenkins/plugins

# --------------------------------------
# Save exact exported plugin list
# --------------------------------------
sudo tee /opt/jenkins-setup/plugins.txt > /dev/null <<'EOF'
commons-lang3-api:3.20.0-109.ve43756e2d2b_4
ionicons-api:94.vcc3065403257
cloudbees-folder:6.1079.vc0975c2de294
antisamy-markup-formatter:173.v680e3a_b_69ff3
asm-api:9.9.1-189.vb_5ef2964da_91
json-path-api:3.0.0-218.vcd4dd1355de2
structs:362.va_b_695ef4fdf9
workflow-step-api:710.v3e456cc85233
commons-text-api:1.15.0-218.va_61573470393
token-macro:477.vd4f0dc3cb_cf1
build-timeout:1.40
bouncycastle-api:2.30.1.83-289.v8426fcd19371
credentials:1491.v6d6145e96e1c
plain-credentials:199.v9f8e1f741799
variant:70.va_d9f17f859e0
ssh-credentials:361.vb_f6760818e8c
credentials-binding:717.v951d49b_5f3a_a_
scm-api:728.vc30dcf7a_0df5
workflow-api:1398.v67030756d3fb_
timestamper:1.30
caffeine-api:3.2.3-194.v31a_b_f7a_b_5a_81
script-security:1399.ve6a_66547f6e1
workflow-support:1015.v785e5a_b_b_8b_22
plugin-util-api:6.1192.v30fe6e2837ff
font-awesome-api:7.2.0-965.ve3840b_696418
bootstrap5-api:5.3.8-895.v4d0d8e47fea_d
javax-activation-api:1.2.0-8
jaxb:2.3.9-143.v5979df3304e6
snakeyaml-api:2.5-149.v72471e9c6371
jakarta-activation-api:2.1.4-1
jakarta-xml-bind-api:4.0.6-12.vb_1833c1231d3
json-api:20251224-185.v0cc18490c62c
jackson2-api:2.21.1-428.vf8dd988fa_d8d
jquery3-api:3.7.1-619.vdb_10e002501a_
echarts-api:6.0.0-1165.vd1283a_3e37d4
snakeyaml-engine-api:3.0.1-5.vd98ea_ff3b_92e
jackson3-api:3.1.0-64.v37e742c35905
prism-api:1.30.0-703.v116fb_3b_5b_b_a_a_
display-url-api:2.217.va_6b_de84cc74b_
checks-api:402.vca_263b_f200e3
junit:1403.vd9d1413fd205
matrix-project:870.v9db_fcfc2f45b_
resource-disposer:0.25
ws-cleanup:0.49
ant:520.vd082ecfb_16a_9
okhttp-api:5.3.2-200.vedb_720a_cf1f8
apache-httpcomponents-client-4-api:4.5.14-269.vfa_2321039a_83
workflow-job:1571.vb_423c255d6d9
gradle:2.18.1203.v2c96b_1243c72
pipeline-milestone-step:138.v78ca_76831a_43
durable-task:664.v2b_e7a_dfff66c
workflow-durable-task-step:1464.v2d3f5c68f84c
pipeline-build-step:584.vdb_a_2cc3a_d07a_
workflow-scm-step:466.va_d69e602552b_
workflow-cps:4259.vf653c2b_8a_b_69
pipeline-groovy-lib:787.ve2fef0efdca_6
joda-time-api:2.14.1-187.vdf2def02b_8a_1
pipeline-model-api:2.2277.v00573e73ddf1
pipeline-stage-step:322.vecffa_99f371c
pipeline-model-extensions:2.2277.v00573e73ddf1
jakarta-mail-api:2.1.5-1
instance-identity:203.v15e81a_1b_7a_38
mailer:525.v2458b_d8a_1a_71
branch-api:2.1280.v0d4e5b_b_460ef
workflow-multibranch:821.vc3b_4ea_780798
pipeline-stage-tags-metadata:2.2277.v00573e73ddf1
pipeline-input-step:540.v14b_100d754dd
workflow-basic-steps:1098.v808b_fd7f8cf4
pipeline-model-definition:2.2277.v00573e73ddf1
workflow-aggregator:608.v67378e9d3db_1
jjwt-api:0.11.5-120.v0268cf544b_89
github-api:1.330-492.v3941a_032db_2a_
mina-sshd-api-common:2.16.0-167.va_269f38cc024
mina-sshd-api-core:2.16.0-167.va_269f38cc024
gson-api:2.13.2-173.va_a_092315913c
git-client:6.5.0
git:5.10.0
github:1.46.0
github-branch-source:1967.vdea_d580c1a_b_a_
pipeline-github-lib:65.v203688e7727e
metrics:4.2.37-494.v06f9a_939d33a_
pipeline-graph-view:803.vb_88f7a_a_1cb_47
eddsa-api:0.3.0.1-29.v67e9a_1c969b_b_
trilead-api:2.284.v1974ea_324382
ssh-slaves:3.1097.v868116049892
matrix-auth:3.2.9
ldap:807.v7d7de30930cf
jsoup:1.22.1-76.v9cdb_2456c0e3
email-ext:1933.v45cec755423f
theme-manager:344.vd7b_e20e046dc
dark-theme:574.va_19f05d54df5
aws-java-sdk2-core:2.33.4-62.vc1a_8df64b_4c9
aws-java-sdk2-ec2:2.33.4-62.vc1a_8df64b_4c9
aws-java-sdk-minimal:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-ec2:1.12.780-480.v4a_0819121a_9e
aws-credentials:254.v978a_5e206a_d7
aws-java-sdk-sqs:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-sns:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-api-gateway:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-cloudformation:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-elasticbeanstalk:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-elasticloadbalancingv2:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-iam:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-ecr:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-cloudfront:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-lambda:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-organizations:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-codedeploy:1.12.780-480.v4a_0819121a_9e
pipeline-aws:1.45
node-iterator-api:72.vc90e81737df1
mina-sshd-api-scp:2.16.0-167.va_269f38cc024
command-launcher:123.v37cfdc92ef67
ec2:2045.v06da_da_a_46422
aws-java-sdk-ecs:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-efs:1.12.780-480.v4a_0819121a_9e
amazon-ecs:1.49
javax-mail-api:1.6.2-11
jdk-tool:83.v417146707a_3d
aws-java-sdk-autoscaling:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-cloudwatch:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-ssm:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-kinesis:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-logs:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-codebuild:1.12.780-480.v4a_0819121a_9e
aws-java-sdk-secretsmanager:1.12.780-480.v4a_0819121a_9e
aws-java-sdk:1.12.780-480.v4a_0819121a_9e
sshd:3.384.vc89b_5e138cf9
codedeploy:1.23
aws-lambda:0.5.10
aws-codebuild:0.59
aws-bucket-credentials:1.0.0
configuration-as-code:2053.vb_0da_47381a_25
aws-java-sdk2-secretsmanager:2.33.4-62.vc1a_8df64b_4c9
aws-secrets-manager-secret-source:2.87.v49cc86c50c3b_
aws-codepipeline:0.49
configuration-as-code-secret-ssm:1.0.1
jenkins-cloudformation-plugin:231.v3b_84a_7a_074ec
aws-sam:1.2.13
terraform:1.0.10
kubernetes-client-api:7.3.1-256.v788a_0b_787114
authentication-tokens:1.144.v5ff4a_5ec5c33
kubernetes-credentials:207.v492f58828b_ed
kubernetes:4423.vb_59f230b_ce53
oauth-credentials:0.660.vce7c108f1f3a_
google-oauth-plugin:1.346.v712b_a_e0d1e60
google-metadata-plugin:0.6.72.v02c1c0e892df
google-storage-plugin:1.372.vdb_857a_f19629
google-kubernetes-engine:0.446.v6a_dd8b_0f678b_
gcp-java-sdk-auth:26.23.0-31.va_efec42c4f8c
pipeline-gcp:22.vcc10eff7c13f
snyk-security-scanner:5.0.1
sonar:2.18.2
aqua-security-scanner:3.2.10
aqua-microscanner:1.0.8
aqua-serverless:1.0.6
github-pullrequest:0.7.3
github-oauth:685.v53b_070455063
pipeline-github:2.8-162.382498405fdc
pipeline-githubnotify-step:49.vf37bf92d2bc8
oss-symbols-api:442.v99039087229b_
javadoc:354.vee1a_660b_4990
jsch:0.2.16-95.v3eecb_55fa_b_78
maven-plugin:3.27
pipeline-maven-api:1672.v1b_d4c0435b_20
config-file-provider:1006.vc7366c201f57
pipeline-maven:1672.v1b_d4c0435b_20
publish-over:238.v1db_583004c9b_
publish-over-ssh:390.vb_f56e7405751
EOF

# --------------------------------------
# Download Jenkins Plugin Installation Manager Tool
# --------------------------------------
sudo wget -O /opt/jenkins-setup/jenkins-plugin-manager.jar \
  https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.14.0/jenkins-plugin-manager-2.14.0.jar

# --------------------------------------
# Install exact pinned plugin set before first Jenkins start
# --latest=false is important so pinned versions stay pinned
# --------------------------------------
sudo java -jar /opt/jenkins-setup/jenkins-plugin-manager.jar \
  --war /usr/share/java/jenkins.war \
  --plugin-file /opt/jenkins-setup/plugins.txt \
  --plugin-download-directory /var/lib/jenkins/plugins \
  --clean-download-directory \
  --latest=false

# --------------------------------------
# Fix permissions
# --------------------------------------
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chown -R jenkins:jenkins /opt/jenkins-setup

# --------------------------------------
# Enable and start Jenkins
# Keep setup wizard enabled for class learning
# --------------------------------------
sudo systemctl enable jenkins
sudo systemctl start jenkins

# --------------------------------------
# Wait for Jenkins to fully start before printing info
# --------------------------------------
until systemctl is-active --quiet jenkins; do
  echo "Waiting for Jenkins to start..."
  sleep 5
done

echo "Jenkins is running!"

# --------------------------------------
# Print initial admin password to cloud-init log
# --------------------------------------
echo "To get Jenkins password run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

# --------------------------------------
# Print installed tool versions to cloud-init log for validation
# --------------------------------------
echo "===== AWS CLI ====="
aws --version || true

echo "===== PYTHON ====="
python3 --version || true

echo "===== JAVA ====="
java -version || true

echo "===== GIT ====="
git --version || true

echo "===== MEMORY ====="
free -h || true

echo "===== TMP ====="
df -h /tmp || true

echo "======================================"
echo "         JENKINS SERVER INFO           "
echo "======================================"

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Jenkins URL: http://$PUBLIC_IP:8080"
echo ""

echo "===== SYSTEM INFO ====="
uname -a

echo ""
echo "===== DISK ====="
df -h

echo ""
echo "===== JENKINS STATUS ====="
sudo systemctl status jenkins --no-pager

echo ""
echo "===== JAVA ====="
java -version

echo ""
echo "===== GIT ====="
git --version

echo "======================================"

echo "===== TERRAFORM ====="
terraform version || true
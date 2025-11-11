# bam-cha.6.1.tf
# format the name or the challenge and time-stamp it

variable "project_name" {
  default = "be_a_man_challenge_6.1"
}

output "formatted_name" {
  value = format("%s-%s", upper(var.project_name), timestamp())
}


locals {
  # Make a fruit salad
  # Step 1: Define your fruits (like your ingredients)
  fruits = ["pineapple", "watermelon", "strawberry"]
  # Step 2: decided added another fruit (mango) to my fruit salad
  bonus_fruit = "mango"

  # Step 3: Use the Terraform function join to "mix" them together along with concat() to include the extra ingredient
  fruit_salad = join(", ", concat(local.fruits, [local.bonus_fruit]))
}

output "fruit_salad" {
  value = "Your fruit salad includes: ${local.fruit_salad}"
}

# summary: 
#   - concat() adds the mango to the existing list
#   - join() mixes it all together in a readable string


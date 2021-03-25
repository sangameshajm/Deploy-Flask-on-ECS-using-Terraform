data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com","ecs.amazonaws.com"]
    }
  }
}

data "template_file" "task_definition_template" {
    template = file("task_definition.json")
    vars = {
      REPOSITORY_URL = replace(aws_ecr_repository.ecr_assignment.repository_url, "https://", "")
    }
}
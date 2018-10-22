resource "aws_cognito_user_pool" "pool" {
  name                       = "cognito_pool"
  email_verification_subject = "Device Verification Code"
  email_verification_message = "Please use the following code {####}"
  sms_verification_message   = "{####} SMS verification code"
  alias_attributes           = ["email", "preferred_username"]
  auto_verified_attributes   = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    reply_to_email_address = "mayur.nagekar@gmailcom"
  }

  password_policy {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 15
    }
  }

  schema {
    attribute_data_type      = "Number"
    developer_only_attribute = true
    mutable                  = true
    name                     = "mynumber"
    required                 = false

    number_attribute_constraints {
      min_value = 2
      max_value = 6
    }
  }

  sms_configuration {
    external_id    = "12345"
    sns_caller_arn = "${aws_iam_role.cidp.arn}"
  }

  tags {
    "Name"    = "cognito-user-pool"
    "Project" = "Infrastructure"
  }
}

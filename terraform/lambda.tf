data "archive_file" "lambda" {
    type = "zip"
    source_file = "../lambdas/hello-world.py"
    output_path = "../lambdas/hello-world-payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
    filename        = "../lambdas/hello-world-payload.zip"
    function_name   = "hello-world-lambda"
    role            = aws_iam_role.iam_for_lambda.arn
    handler         = "hello-world.lambda_handler"

    source_code_hash = data.archive_file.lambda.output_base64sha256
    runtime         = "python3.9"
    timeout         = 10
}


name: Terraform Apply, Destroy, and Stop/Start Instances

on:
  schedule:
    - cron: '*/2 * * * *'  # Run every 2 minutes

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.0.0  # Replace with your desired Terraform version

      - name: Configure AWS credentials
        run: |
          echo "AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}" >> $GITHUB_ENV
          echo "AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}" >> $GITHUB_ENV

      - name: Terraform Init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve

      - name: Wait for 2 minutes
        run: sleep 120

      - name: Terraform Destroy
        run: terraform destroy -auto-approve

      - name: Stop EC2 Instances
        run: aws ec2 stop-instances --instance-ids $(terraform output instance_ids) --region us-east-1
        # Replace 'us-east-1' with your desired AWS region

      # Optionally, you can add a step to start instances if needed.
      - name: Start EC2 Instances
        run: aws ec2 start-instances --instance-ids your-instance-ids --region us-east-1
        # Uncomment and replace 'us-east-1' and 'your-instance-ids' with your region and instance IDs.

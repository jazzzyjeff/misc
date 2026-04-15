import os


def lambda_handler(event, context):
    os.system("LC_ALL='C.UTF-8' ansible-playbook main.yml")

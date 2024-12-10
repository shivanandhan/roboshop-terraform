git pull;
 if [ $# -ne 2 ]; then
  echo "input missing"
  echo "usage: bash run.sh <component-name> <env>"
  exit 1
 fi
ansible-playbook -i $1-$2.kndevops72.online, -e ansible_user=ec2-user -e ansible_password=DevOps321 -e env=dev -e app_name=$1 roboshop.yml

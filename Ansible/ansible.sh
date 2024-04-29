vi /home/bob/playbooks/replace/playbook.yml



Update it as below:


---
- hosts: localhost
  connection: local
  vars:
    dialogue: "The name is Bourne, James Bourne!"
  tasks:
    - template:
        src: name.txt.j2
        dest: /tmp/name.txt

Execute the playbook:


cd /home/bob/playbooks/replace/
ansible-playbook -i inventory playbook.yml
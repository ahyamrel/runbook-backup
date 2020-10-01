# runbook-backup

<img src="https://ci.appveyor.com/api/projects/status/32r7s2skrgm9ubva?svg=true&passingText=master%20-%20WORKING" alt="Project Badge">

After running for some time runbooks backup and versioning automation I'm gladly sharing an Open Source version of the code.

## How to Set up
1. Create a **private** Github repository to not share publicly your runbooks and [set SSH Key](https://docs.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) if you haven't.
2. Clone Git Repo to created Private repo.
3. Run Powershell Script for sync (Optional in a script: configure Source Control for Runbooks)
4. (Optional) Create a [Task scheduler to run synchronization.](https://blog.netwrix.com/2018/07/03/how-to-automate-powershell-scripts-with-task-scheduler/)

Simple as that and you're ready to go :+1:

## How does it look
All runbooks are organized in a Subscription > Resource Group > Automation Account in README.md
![All runbooks are organized in a Subscription > Resource Group > Automation Account in README.md](https://imgur.com/ZIRM6bU.png)

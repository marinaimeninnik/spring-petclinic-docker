## Part 1
### 1. Configure static and dynamic agents
### Static agent
On static agent machine java JDK should be installed.
Statis node configurations in jenkins
<br>![task1_3](IMG/task1_1_1.png)</br>

Launch slave agents via Java Web Start on slave's machine
<br>![task1_3](IMG/task1_1_2.png)</br>

Node connected
<br>![task1_3](IMG/task1_1_5.png)</br>
<br>![task1_3](IMG/task1_1_3.png)</br>

Job launched successfully via static node
<br>![task1_3](IMG/task1_1_4.png)</br>

### 2. Use credentials for sensitive data (github/gitlab connactions etc.)

...

### 3. Access rights configuration. Create 3 groups (dev, qa, devops and grant them different rights)

[Role-based Authorization Strategy plugin](https://plugins.jenkins.io/role-strategy/) has been used for access rights configuration

Roles created and configured on "Manage role" screen (manage/role-strategy/)
<br>![task1_3](IMG/task1_3_1.png)</br>

Users associated with certain roles on Assign Roles page (manage/role-strategy/assign-roles)
<br>![task1_3](IMG/task1_3_2.png)</br>

## Part 2

some changes
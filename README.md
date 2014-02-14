#TeamStyleDev队式开发培训
----------

model:user
-
- administration:integer **管理权限等级**

    `0:管理员,只允许用户名为admin,拥有一切权限`  
    `1:培训员,负责发布培训信息,上传培训资料,批阅培训作业`  
    `2:指导员`  
    `3:学员`  
- salt:string **用户注册时的随机密钥,利用系统时间用户ID和随机数使用MD5算法生成**
- hashed_password:string **利用salt和密码使用SHA512算法生成**
- name:string **用户名暂定不超过20个Unicode字符,作为识别用户的唯一凭证,只有管理员可以更改**
- gender:boolean **性别**
- class_name:string **所在班级**
- email:string **作为找回密码和下发信息的第一渠道,凭管理员授权更改**
- renren:integer **人人ID,暂时没啥用**
- qq:integer **QQ号,暂时没啥用**
- mobile:integer **手机号,暂时没啥用**

model:upload
-
- name:string **文件名**
- information:text **文件介绍**
- path:string **文件位置**
- category:string **文件类别**
- course_id:integer **文件所属课程**
- assignment_id:integer **文件所属作业**

model:session
-
- user_id:integer **用户ID**
- remember_token:string **token**

model:course
-
- name:string **课程名称**
- user_id:integer **主教师ID**
- category:string **课程类别**
- information:text **课程介绍**

model:assignment
-
- name:string **作业名称**
- information:text **作业说明**
- course_id:integer **所属课程ID**
- startat:datetime **开放日期**
- deadline:datetime **截止日期**


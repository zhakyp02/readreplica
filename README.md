+ If you are using a different repository for 'rr', 
 you can comment it out data terraform_remote_state and replace  with from your 
  master instance's state file, such as the bucket name and prefix.
+ If you are using the same module as your master instance, 
 there's no need to comment it out. Simply configure the master instance name.

+ Use your tfvars

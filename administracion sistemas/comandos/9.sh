mkdir mybackups                                           
tar -cvf mybackups/udev.tar /etc/udev                     
# tar: Removing leading `/' from member names                                     
# /etc/udev/                                                                      
# /etc/udev/rules.d/                                                              
# /etc/udev/rules.d/70-persistent-cd.rules                                        
# /etc/udev/rules.d/README                                                        
# /etc/udev/hwdb.d/                                                               
# /etc/udev/udev.conf                                                             
ls mybackups                                              
# udev.tar                           

tar -tvf mybackups/udev.tar                               
# drwxr-xr-x root/root         0 2021-02-08 15:07 etc/udev/                       
# drwxr-xr-x root/root         0 2021-02-08 15:08 etc/udev/rules.d/               
# -rw-r--r-- root/root       306 2021-02-08 15:08 etc/udev/rules.d/70-persistent-cd.rules                                                                         
# -rw-r--r-- root/root      1157 2021-02-08 15:08 etc/udev/rules.d/README         
# drwxr-xr-x root/root         0 2021-01-06 21:04 etc/udev/hwdb.d/                
# -rw-r--r-- root/root       218 2021-02-08 15:08 etc/udev/udev.conf    

tar -zcvf mybackups/udev.tar.gz /etc/udev
# tar: Removing leading `/' from member names                                     
# /etc/udev/                                                                      
# /etc/udev/rules.d/                                                              
# /etc/udev/rules.d/70-persistent-cd.rules                                        
# /etc/udev/rules.d/README                                                        
# /etc/udev/hwdb.d/                                                               
# /etc/udev/udev.conf                                                              
ls -lh mybackups/                                         
# total 16K                                                                       
# -rw-rw-r-- 1 sysadmin sysadmin  10K Feb  9 17:34 udev.tar                       
# -rw-rw-r-- 1 sysadmin sysadmin 1.2K Feb  9 17:45 udev.tar.gz  

cd mybackups                                            
ls                                            
# udev.tar  udev.tar.gz                                                         
tar -xvf udev.tar.gz                            
# etc/udev/                                                                       
# etc/udev/rules.d/                                                               
# etc/udev/rules.d/70-persistent-cd.rules                                         
# etc/udev/rules.d/README                                                         
# etc/udev/hwdb.d/                                                                
# etc/udev/udev.conf                                              
ls                                            
# etc  udev.tar  udev.tar.gz                                                    
ls etc                                          
# udev                                                                            
ls etc/udev                                     
# hwdb.d  rules.d  udev.conf                                                      
ls etc/udev/rules.d
# 70-persistent-cd.rules  README     

tar -rvf udev.tar /etc/hosts             
# tar: Removing leading `/' from member names                               
# /etc/hosts                                                                
tar -tvf udev.tar                               
# drwxr-xr-x root/root         0 2021-02-08 15:07 etc/udev/                       
# drwxr-xr-x root/root         0 2021-02-08 15:08 etc/udev/rules.d/               
# -rw-r--r-- root/root       306 2021-02-08 15:08 etc/udev/rules.d/70-persistent-cd.rules                                                                         
# -rw-r--r-- root/root      1157 2021-02-08 15:08 etc/udev/rules.d/README         
# drwxr-xr-x root/root         0 2021-01-06 21:04 etc/udev/hwdb.d/                
# -rw-r--r-- root/root       218 2021-02-08 15:08 etc/udev/udev.conf              
# -rw-r--r-- root/root       172 2024-02-09 17:33 etc/hosts    

cp /usr/share/dict/words .                
ls -l words                               
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words                  
gzip words                                
ls -l words.gz                            
# -rw-r--r-- 1 sysadmin sysadmin 259983 Feb  9 17:59 words.gz  

ls -l words.gz                                  
# -rw-r--r-- 1 sysadmin sysadmin 259983 Feb  9 17:59 words.gz               
gunzip words.gz                                 
ls -l words                                     
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words 

ls -l words                                     
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words
bzip2 words
ls -l words.bz2                                 
# -rw-r--r-- 1 sysadmin sysadmin 345560 Feb  9 17:59 words.bz2

ls -l words.bz2                                 
# -rw-r--r-- 1 sysadmin sysadmin 345560 Feb  9 17:59 words.bz2 
bunzip2 words.bz2                               
ls -l words                                     
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words

ls -l words                                     
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words                        
xz words                                        
ls -l words.xz                                  
# -rw-r--r-- 1 sysadmin sysadmin 198756 Feb  9 17:59 words.xz

ls -l words.xz                                  
# -rw-r--r-- 1 sysadmin sysadmin 198756 Feb  9 17:59 words.xz                  
unxz words.xz                                   
ls -l words                                     
# -rw-r--r-- 1 sysadmin sysadmin 971578 Feb  9 17:59 words

zip words.zip words                             
#   adding: words (deflated 73%)                                                  
ls -l words.zip                                 
# -rw-rw-r-- 1 sysadmin sysadmin 260119 Feb  9 18:23 words.zip        

zip -r udev.zip /etc/udev                       
#   adding: etc/udev/ (stored 0%)                                                 
#   adding: etc/udev/rules.d/ (stored 0%)                                         
#   adding: etc/udev/rules.d/70-persistent-cd.rules (deflated 29%)                
#   adding: etc/udev/rules.d/README (deflated 50%)                                
#   adding: etc/udev/hwdb.d/ (stored 0%)                                          
#   adding: etc/udev/udev.conf (deflated 24%)                                         
ls -l udev.zip                                  
# -rw-rw-r-- 1 sysadmin sysadmin 2000 Feb  9 18:25 udev.zip  

unzip -l udev.zip                               
# Archive:  udev.zip                                                              
#   Length      Date    Time    Name                                              
# ---------  ---------- -----   ----                                              
#         0  2021-02-08 15:07   etc/udev/                                         
#         0  2021-02-08 15:08   etc/udev/rules.d/                                 
#       306  2021-02-08 15:08   etc/udev/rules.d/70-persistent-cd.rules           
#      1157  2021-02-08 15:08   etc/udev/rules.d/README                           
#         0  2021-01-06 21:04   etc/udev/hwdb.d/                                  
#       218  2021-02-08 15:08   etc/udev/udev.conf                                
# ---------                     -------                                           
#      1681                     6 files

rm -r etc                                       
unzip udev.zip                                  
# Archive:  udev.zip                                                              
#    creating: etc/udev/                                                          
#    creating: etc/udev/rules.d/                                                  
#   inflating: etc/udev/rules.d/70-persistent-cd.rules                            
#   inflating: etc/udev/rules.d/README                                            
#    creating: etc/udev/hwdb.d/                                                   
#   inflating: etc/udev/udev.conf             
常用命令:

开关服务
sudo systemctl restart slurmd slurmctld
sudo systemctl restart slurmd 
sudo systemctl restart munge

服务状态
sudo systemctl status slurmd  
sudo systemctl status slurmctld 
sudo systemctl status munge

查看日志
tail -f /var/log/slurm/slurmctld.log

手动启动节点
sudo scontrol update NodeName=worker01 State=RESUME

查看状态：
sinfo

查看队列
squeue

加入排队
sbatch

运行
srun
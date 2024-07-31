SELECT a.USER_CONCURRENT_QUEUE_NAME "MANAGER",a.MAX_PROCESSES "TOTAL_SLOTS",
(a.MAX_PROCESSES-sum(decode(b.PHASE_CODE,'R',decode(b.STATUS_CODE,'R',1,0),0))) "FREE_SLOTS", 
round((((a.MAX_PROCESSES-sum(decode(b.PHASE_CODE,'R',decode(b.STATUS_CODE,'R',1,0),0)))/(a.MAX_PROCESSES))*100),0) "FREE_%",
sum(decode(b.PHASE_CODE,'R',decode(b.STATUS_CODE,'R',1,0),0)) RUNNING_NORMAL,
sum(decode(b.PHASE_CODE,'P',decode(b.STATUS_CODE,'I',1,0),0)) PENDING_NORMAL,
sum(decode(b.PHASE_CODE,'P',decode(b.STATUS_CODE,'Q',1,0),0)) PENDING_STANDBY
FROM FND_CONCURRENT_QUEUES_VL a, FND_CONCURRENT_WORKER_REQUESTS b
where a.concurrent_queue_id = b.concurrent_queue_id
AND b.Requested_Start_Date<=SYSDATE
and a.USER_CONCURRENT_QUEUE_NAME in ('STANDARD','FAST','EXPRESS','Conflict Resolution Manager','Inventory Manager')
GROUP BY a.USER_CONCURRENT_QUEUE_NAME,a.MAX_PROCESSES
order by 2 desc;

set lines 200
col username for a30
col account_status for a30
col profile for a30
col GRACETIME_DAYS for a15
col PWD_LIFETIME_DAYS for a20
select u.username, 
       u.account_status,
       u.profile,
       TO_CHAR(u.expiry_date,'DD-MON-YYYY HH24:MI:SS') as "EXPIRE_DATE",
       -- 12c only TO_CHAR(u.last_login,'DD-MON-YYYY HH24:MI:SS'),
       (select LIMIT from dba_profiles where profile = u.profile and RESOURCE_TYPE = 'PASSWORD' and RESOURCE_NAME = 'PASSWORD_GRACE_TIME') as "GRACETIME_DAYS",
       (select LIMIT from dba_profiles where profile = u.profile and RESOURCE_TYPE = 'PASSWORD' and RESOURCE_NAME = 'PASSWORD_LIFE_TIME') as "PWD_LIFETIME_DAYS"
from dba_users u, dba_profiles p
WHERE u.expiry_date < sysdate+7 and account_status IN ( 'OPEN', 'EXPIRED(GRACE)' )
group by u.username, u.account_status, u.profile, u.expiry_date
order by u.expiry_date desc;

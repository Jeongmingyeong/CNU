alter session set "_ORACLE_SCRIPT"=true;
create user d202102699 identified by 1234;
grant connect, resource to d202102699;
alter user d123456789 quota unlimited on users;
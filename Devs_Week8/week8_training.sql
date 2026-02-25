select * from tm;

select * from equipmentparams where equipmentid='2693' and param_name in ('TRACK', 'TMPOSITION');

select * from glo_handlerlist where upper(condition) like ('%REGISTER%');

--select distinct handlertype from glo_handlerlist;

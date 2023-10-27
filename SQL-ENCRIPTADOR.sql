use master
go

if exists(Select name from sys.sysdatabases where name='BDEncripta')
	Drop database BDEncripta
go
Create database BDEncripta
go
use BDEncripta
go
create table usuario
(
codigo char(7)not null primary key,
nick varchar(20)not null,
usuario varchar(30)not null,
contraseña varchar(200)not null
)
go

--Creando el Procedimiento para Generar el codigo y Encriptar la contraseña
create procedure usp_usuario
@nick varchar(20),@usuario varchar(30),@password varchar(200),@nt varchar(200) output
as
declare @codigo char(7),@n1 int
select @codigo=max(codigo)from usuario
if @codigo is null
begin 
  set @codigo='USU-001'
end
else
begin
  set @n1=cast(right(@codigo,3)as int)+1
  set @codigo='USU-'+  right('000'+cast (@n1 as varchar(3)),3)
end
begin
  declare @n int,@c varchar(2)
  declare @simbolo char(1)
  set @nt=''
  set @password=reverse(ltrim(rtrim(@password)))
  set @n=0
  while @n<len(@password)
    begin
      set @n=@n+1
      set @c=cast(ascii(upper((substring(@password,@n,2))))+1 as char(2))
      set @simbolo=char(floor(rand()*250+1))
      set @nt=@nt+@simbolo+@c
    end
end
insert usuario values(@codigo,@nick,@usuario,@nt)
return
go


execute usp_usuario 'JDiaz','Johnny Diaz','123',''
execute usp_usuario 'CSantana','Carlos Santana','alfa',''
execute usp_usuario 'ALora','Alex Lora','beta',''
Select * from usuario
go


--Procedimiento para Desencriptar
create procedure usp_desencriptar
@t varchar(200)
as
begin
  declare @n int,@c varchar(2),@nt varchar(200)
  declare @simbolo char(1)
  set @nt=''
  set @n=2
while @n<len(@t)
begin
 set @c=char(cast(substring(@t,@n,2)as int)-1)
 set @n=@n+3
 set @nt=@nt+@c
end
set @nt=reverse(ltrim(rtrim(@nt)))
select clave=@nt
end
go


execute usp_desencriptar 'u89q89Ô89'
select*from usuario







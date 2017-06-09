show user;
-- USER이(가) "MYORAUSER"입니다.

-- 이미지 넣기 
create table spring_img_advertise
(imgno          number not null
,imgfilename    varchar2(100) not null
,constraint PK_spring_img_advertise primary key(imgno)
);

create sequence seq_spring_img_advertise
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into spring_img_advertise values(seq_spring_img_advertise.nextval, '미샤.png');
insert into spring_img_advertise values(seq_spring_img_advertise.nextval, '원더플레이스.png');
insert into spring_img_advertise values(seq_spring_img_advertise.nextval, '레노보.png');
insert into spring_img_advertise values(seq_spring_img_advertise.nextval, '동원.png');
commit;

select *
from spring_img_advertise
order by imgno desc;

select *
from user_tables;


select *  
from jsp_member;

create table spring_jsp_member
as
select *  
from jsp_member;
-- NOT NULL 조건은 그대로 복사가 되지만
-- 제약 조건(PK,UQ,FK 등)은 복사가 되지 않는다.

-- 회원테이블
select *
from spring_jsp_member;

desc spring_jsp_member;

-- 제약 조건 조회하기 
select *
from user_constraints
where table_name = 'SPRING_JSP_MEMBER';

-- 제약 조건 추가하기
alter table spring_jsp_member
add constraint PK_spring_jsp_member primary key(idx);

alter table spring_jsp_member
add constraint UQ_spring_jsp_member unique(userid);

alter table spring_jsp_member
add constraint CK_spring_jsp_member check(status in (0,1));

commit;

-- 제약조건이 걸려있는 컬럼명 조회하기
select *
from user_cons_columns
where table_name = 'SPRING_JSP_MEMBER';


select *
from user_cons_columns A join user_constraints B
on A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
where A.table_name = 'SPRING_JSP_MEMBER';

----------- 비밀 번호 암호화 (DB 개발자도 알 수 없게!) --------------
                ----- 중요!!! -----
      -- 사용자의 암호는 DBA도 몰라야한다. -- 
  -- 암호 변경은 DBA가 알려주는 것이 아니라, DBA도 모르기 때문에
  -- 사용자가 새로운 암호로 변경할 수 있도록 해야한다. 
  
create or replace function func_encrypted_password
(p_password     in     varchar2)
return varchar2
is
  v_password_length     number(2) := 0;
  v_lack_length         number(2) := 0;
  v_alphabet_length     number(2) := 0;
  v_decimal_length      number(2) := 0;
  v_special_length      number(2) := 0;
  v_ascii               number(3);
  v_result              varchar2(100) := '';
begin
  select length(p_password), 25-length(p_password)
    into v_password_length, v_lack_length
  from dual;

  FOR i in 1..length(p_password) loop
      v_ascii := ascii(substr(p_password, i, 1));
      
      IF ( (65 <= v_ascii and v_ascii <= 90) or 
           (97 <= v_ascii and v_ascii <= 122) )
        then v_alphabet_length := v_alphabet_length + 1;
        
      elsif(48 <= v_ascii and v_ascii <= 57) then v_decimal_length := v_decimal_length + 1;
      else 
        v_special_length := v_special_length + 1;
  
      end if;      
    end loop;
    
      v_result := dbms_random.String('P', v_alphabet_length) || 
                    substr(p_password,1,2) || 
                  dbms_random.String('P', v_decimal_length) ||
                    substr(p_password,3,3) || 
                  dbms_random.String('P', v_special_length) ||
                    substr(p_password,6,3) ||
                  dbms_random.String('P', v_lack_length);
                  
      select reverse(v_result) into v_result
      from dual;
      
      return v_result;
      
end func_encrypted_password;


-- 복호화
create or replace function func_decrypted_password
(p_userid       in     varchar2
,p_password     in     varchar2)
return varchar2
is
  v_password_length     number(2) := 0;
  v_lack_length         number(2) := 0;
  v_alphabet_length     number(2) := 0;
  v_decimal_length      number(2) := 0;
  v_special_length      number(2) := 0;
  v_ascii               number(3);
  v_result              varchar2(100) := '';
begin
  select length(p_password), 25-length(p_password)
    into v_password_length, v_lack_length
  from dual;

  FOR i in 1..length(p_password) loop
      v_ascii := ascii(substr(p_password, i, 1));
      
      IF ( (65 <= v_ascii and v_ascii <= 90) or 
           (97 <= v_ascii and v_ascii <= 122) )
        then v_alphabet_length := v_alphabet_length + 1;
        
      elsif(48 <= v_ascii and v_ascii <= 57) then v_decimal_length := v_decimal_length + 1;
      else 
        v_special_length := v_special_length + 1;
  
      end if;      
    end loop;
    
      select reverse(pwd) -- , 4#qwQGr[er1/234l%'DTjJxoi s5v1F
            into v_result
      from spring_jsp_member
      where userid = p_userid;
    
    
      v_result := substr(v_result, v_alphabet_length+1,2) || -- qw
                  substr(v_result, v_alphabet_length+2+v_decimal_length+1,3) || -- er1
                  substr(v_result, v_alphabet_length+2+v_decimal_length+3+v_special_length+1,3); -- 234
                  
      return v_result;
      
end func_decrypted_password;


-- LOGINCHECK
-- 로그인 여부 알아오기 
select case( select count(*)
            from spring_jsp_member
            where userid = 'sandew38' and func_decrypted_password('sandew38','qwer1234$') = substr('qwer1234$',1,8) )
        when 1 then 1 
        else ( case(select count(*)
                from spring_jsp_member
                where userid = 'sandew38') 
                when 1 then 0 
                else -1
                end
                )
        end as LOGINCHECK
from dual;

select *
from TBL_ENCRYPTEDMEMBER ;



-- 회원테이블
select *
from spring_jsp_member;

alter table spring_jsp_member
rename column password to pwd;

alter table spring_jsp_member
rename column address1 to addr1;

alter table spring_jsp_member
rename column address2 to addr2;

commit;

update spring_jsp_member set password = func_encrypted_password('qwer1234$');

-- 회원 한 명의 정보 가져오기

select *
from spring_jsp_member
where status = 1 and userid = 'sandew38';


-- 글 작성 관련 테이블 생성

create table spring_tblBoard
(seq         number                not null   -- 글번호
,userid      varchar2(20)          not null   -- 사용자ID
,name        Nvarchar2(20)         not null   -- 글쓴이
,subject     Nvarchar2(200)        not null   -- 글제목
,content     Nvarchar2(2000)       not null   -- 글내용    -- clob
,pw          varchar2(20)          not null   -- 글암호
,readCount   number default 0      not null   -- 글조회수
,regDate     date default sysdate  not null   -- 글쓴시간
,status      number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글 
,constraint  PK_spring_tblBoard_seq primary key(seq)
,constraint  FK_spring_tblBoard_userid foreign key(userid) references spring_jsp_member(userid)
,constraint  CK_spring_tblBoard_status check( status in(0,1) )
);

create sequence spring_boardSeq
start with 1
increment by 1
nomaxvalue 
nominvalue
nocycle
nocache;

commit;

select *
from spring_tblBoard 
order by seq desc;

rollback;

insert into spring_tblBoard (seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'sandew38', '김영주', '안녕하세요', '오늘은 수요일입니당', 'qwer1234$', default, default, default);





   ----- **** 댓글 테이블 생성 **** -----
  
create table spring_tblComment
(seq        number               not null   -- 댓글번호
,userid     varchar2(20)         not null   -- 사용자ID
,name       varchar2(20)         not null   -- 성명
,content    varchar2(1000)       not null   -- 댓글내용
,regDate    date default sysdate not null   -- 작성일자
,parentSeq  number               not null   -- 원게시물 글번호
,status     number(1) default 1  not null   -- 글삭제여부
                                            -- 1 : 사용가능한 글,  0 : 삭제된 글
                                            -- 댓글은 원글이 삭제되면 자동적으로 삭제되어야 한다.
,constraint PK_spring_tblComment_seq primary key(seq)
,constraint FK_spring_tblComment_userid foreign key(userid)
                                    references spring_jsp_member(userid)
,constraint FK_spring_tblComment_parentSeq foreign key(parentSeq) 
                                      references spring_tblBoard(seq)
,constraint CK_spring_tblComment_status check( status in(1,0) ) 
);

create sequence spring_commentSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

/*
 댓글쓰기(spring_tblComment 테이블)를 성공하면 원게시물(spring_tblBoard 테이블)에
 댓글의 갯수(1씩 증가)를 알려주는 컬럼 commentCount 을 추가하겠다.
*/
alter table spring_tblBoard
add commentCount number default 0 not null;

select *
from spring_tblBoard
order by seq desc;


select *
from spring_tblComment
order by seq desc; 


alter table spring_tblBoard
add constraint CK_spring_tblBoard check(commentcount >=0 and commentcount <= 2);

alter table spring_tblBoard
drop constraint CK_spring_tblBoard;

commit;

select seq, userid, name, subject, content, pw, readCount, regDate, status, commentCount
from spring_tblBoard 
where status = 1 and seq = 9
order by seq desc;

select *
from spring_tblBoard;

select *
from spring_jsp_member;

rollback;

update spring_jsp_member set status = 1;

--------- **** 페이징 처리 작업 하기 **** -----------------
insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd1', '홍길동1', 'Hong Kil Dong1 입니다.', '안녕하세요? Hong Kil Dong1 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd2', '홍길동2', 'Hong Kil Dong2 입니다.', '안녕하세요? Hong Kil Dong2 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd3', '홍길동3', 'Hong Kil Dong3 입니다.', '안녕하세요? Hong Kil Dong3 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd4', '홍길동4', 'Hong Kil Dong4 입니다.', '안녕하세요? Hong Kil Dong4 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd5', '홍길동5', 'Hong Kil Dong5 입니다.', '안녕하세요? Hong Kil Dong5 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd6', '홍길동6', 'Hong Kil Dong6 입니다.', '안녕하세요? Hong Kil Dong6 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd7', '홍길동7', 'Hong Kil Dong7 입니다.', '안녕하세요? Hong Kil Dong71 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd8', '홍길동8', 'Hong Kil Dong8 입니다.', '안녕하세요? Hong Kil Dong8 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd9', '홍길동9', 'Hong Kil Dong9 입니다.', '안녕하세요? Hong Kil Dong9 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd10', '홍길동10', 'Hong Kil Dong10 입니다.', '안녕하세요? Hong Kil Dong10 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg1', '박보검1', '박보검1 입니다.', '안녕하세요? 박보검1 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg2', '박보검2', '박보검2 입니다.', '안녕하세요? 박보검2 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg3', '박보검3', '박보검3 입니다.', '안녕하세요? 박보검3 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg4', '박보검4', '박보검4 입니다.', '안녕하세요? 박보검4 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg5', '박보검5', '박보검5 입니다.', '안녕하세요? 박보검5 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg6', '박보검6', '박보검6 입니다.', '안녕하세요? 박보검6 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg7', '박보검7', '박보검7 입니다.', '안녕하세요? 박보검7 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg8', '박보검8', '박보검8 입니다.', '안녕하세요? 박보검8 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg9', '박보검9', '박보검9 입니다.', '안녕하세요? 박보검9 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg10', '박보검10', '박보검10 입니다.', '안녕하세요? 박보검10 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg1', '박보검1', 'Park Bo Gum1 입니다.', '안녕하세요? Park Bo Gum1 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg2', '박보검2', 'Park Bo Gum2 입니다.', '안녕하세요? Park Bo Gum2 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg3', '박보검3', 'Park Bo Gum3 입니다.', '안녕하세요? Park Bo Gum3 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg4', '박보검4', 'Park Bo Gum4 입니다.', '안녕하세요? Park Bo Gum4 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg5', '박보검5', 'Park Bo Gum5 입니다.', '안녕하세요? Park Bo Gum5 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg6', '박보검6', 'Park Bo Gum6 입니다.', '안녕하세요? Park Bo Gum6 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg7', '박보검7', 'Park Bo Gum7 입니다.', '안녕하세요? Park Bo Gum7 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg8', '박보검8', 'Park Bo Gum8 입니다.', '안녕하세요? Park Bo Gum8 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg9', '박보검9', 'Park Bo Gum9 입니다.', '안녕하세요? Park Bo Gum9 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'parkbg10', '박보검10', 'Park Bo Gum10 입니다.', '안녕하세요? Park Bo Gum10 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd1', '홍길동1', '아버지를 아버지라 부르지1 입니다.', '안녕하세요? 아버지를 아버지라 부르지1 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd2', '홍길동2', '아버지를 아버지라 부르지2 입니다.', '안녕하세요? 아버지를 아버지라 부르지2 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd3', '홍길동3', '아버지를 아버지라 부르지3 입니다.', '안녕하세요? 아버지를 아버지라 부르지3 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd4', '홍길동4', '아버지를 아버지라 부르지4 입니다.', '안녕하세요? 아버지를 아버지라 부르지4 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd5', '홍길동5', '아버지를 아버지라 부르지5 입니다.', '안녕하세요? 아버지를 아버지라 부르지5 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd6', '홍길동6', '아버지를 아버지라 부르지6 입니다.', '안녕하세요? 아버지를 아버지라 부르지6 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd7', '홍길동7', '아버지를 아버지라 부르지7 입니다.', '안녕하세요? 아버지를 아버지라 부르지7 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd8', '홍길동8', '아버지를 아버지라 부르지8 입니다.', '안녕하세요? 아버지를 아버지라 부르지8 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd9', '홍길동9', '아버지를 아버지라 부르지9 입니다.', '안녕하세요? 아버지를 아버지라 부르지9 입니다.', '1234', default, default, default);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status)
values(spring_boardSeq.nextval, 'hongkd10', '홍길동10', '아버지를 아버지라 부르지10 입니다.', '안녕하세요? 아버지를 아버지라 부르지10 입니다.', '1234', default, default, default);

commit;


create table tbl_test
(userid varchar2(20) not null
, name varchar2(20) not null
,constraint tbl_test primary key(userid)
)


select rownum as rno, userid, name 
from (
select userid, name
from tbl_test
)V;

declare
  cnt number(3) := 0;
  begin
    loop
    insert into tbl_test (userid, name)
    values('test'||cnt, '테스트'||cnt);
    cnt := cnt +1;
      exit when cnt > 10;
    end loop;
end;


-----------------------------------------------------------
         ---- *** 답변형 게시판 *** ----
-----------------------------------------------------------

drop table spring_tblComment purge;
drop table spring_tblBoard purge;


create table spring_tblBoard
(seq           number                not null   -- 글번호
,userid        varchar2(20)          not null   -- 사용자ID
,name          Nvarchar2(20)         not null   -- 글쓴이
,subject       Nvarchar2(200)        not null   -- 글제목
,content       Nvarchar2(2000)       not null   -- 글내용    -- clob
,pw            varchar2(20)          not null   -- 글암호
,readCount     number default 0      not null   -- 글조회수
,regDate       date default sysdate  not null   -- 글쓴시간
,status        number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글 
,commentCount  number default 0      not null   -- 댓글수
,groupno       number                not null   -- 답변글쓰기에 있어서 그룹번호
                                                -- 원글(부모글)과 답변글은 동일한 groupno 를 가진다. 
                                                -- 답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.  
                                                
,fk_seq        number default 0      not null   -- fk_seq 컬럼은 절대로 foreign key가 아니다.
                                                -- fk_seq 컬럼은 자신의 글(답변글)에 있어서 
                                                -- 원글(부모글)이 누구인지에 대한 정보값이다.
                                                -- 답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은 
                                                -- 원글(부모글)의 seq 컬럼의 값을 가지게 되며,
                                                -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.
                                                
,depthno       number default 0       not null  -- 답변글쓰기에 있어서 답변글 이라면                                                
                                                -- 원글(부모글)의 depthno + 1 을 가지게 되며,
                                                -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.
,constraint  PK_spring_tblBoard_seq primary key(seq)
,constraint  FK_spring_tblBoard_userid foreign key(userid) 
                                       references spring_jsp_member(userid)
,constraint  CK_spring_tblBoard_status check( status in(0,1) )
);

-- drop sequence spring_boardSeq;

create sequence spring_boardSeq
start with 1
increment by 1
nomaxvalue 
nominvalue
nocycle
nocache;


create table spring_tblComment
(seq        number               not null   -- 댓글번호
,userid     varchar2(20)         not null   -- 사용자ID
,name       varchar2(20)         not null   -- 성명
,content    varchar2(1000)       not null   -- 댓글내용
,regDate    date default sysdate not null   -- 작성일자
,parentSeq  number               not null   -- 원게시물 글번호
,status     number(1) default 1  not null   -- 글삭제여부
                                            -- 1 : 사용가능한 글,  0 : 삭제된 글
                                            -- 댓글은 원글이 삭제되면 자동적으로 삭제되어야 한다.
,constraint PK_spring_tblComment_seq primary key(seq)
,constraint FK_spring_tblComment_userid foreign key(userid)
                                        references spring_jsp_member(userid)
,constraint FK_spring_tblComment_parentSeq foreign key(parentSeq) 
                                           references spring_tblBoard(seq)
,constraint CK_spring_tblComment_status check( status in(1,0) ) 
);

-- drop sequence spring_commentSeq;

create sequence spring_commentSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd1', '홍길동1', '홍길동1 입니다.', '안녕하세요? 홍길동1 입니다.', '1234', default, default, default, 4);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd2', '홍길동2', '홍길동1 입니다.', '안녕하세요? 홍길동1 입니다.', '1234', default, default, default, 5);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd3', '홍길동3', '홍길동3 입니다.', '안녕하세요? 홍길동3 입니다.', '1234', default, default, default, 6);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd4', '홍길동4', '홍길동4 입니다.', '안녕하세요? 홍길동4 입니다.', '1234', default, default, default, 7);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd5', '홍길동5', '홍길동5 입니다.', '안녕하세요? 홍길동5 입니다.', '1234', default, default, default, 8);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd6', '홍길동6', '홍길동6 입니다.', '안녕하세요? 홍길동6 입니다.', '1234', default, default, default, 9);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd7', '홍길동7', '홍길동7 입니다.', '안녕하세요? 홍길동7 입니다.', '1234', default, default, default, 10);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd8', '홍길동8', '홍길동8 입니다.', '안녕하세요? 홍길동8 입니다.', '1234', default, default, default, 11);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd9', '홍길동9', '홍길동9 입니다.', '안녕하세요? 홍길동9 입니다.', '1234', default, default, default, 12);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd10', '홍길동10', '홍길동10 입니다.', '안녕하세요? 홍길동10 입니다.', '1234', default, default, default, 13);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd1', '홍길동1', 'Hong Kil Dong1 입니다.', '안녕하세요? Hong Kil Dong1 입니다.', '1234', default, default, default, 14);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd2', '홍길동2', 'Hong Kil Dong2 입니다.', '안녕하세요? Hong Kil Dong2 입니다.', '1234', default, default, default, 15);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd3', '홍길동3', 'Hong Kil Dong3 입니다.', '안녕하세요? Hong Kil Dong3 입니다.', '1234', default, default, default, 16);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd4', '홍길동4', 'Hong Kil Dong4 입니다.', '안녕하세요? Hong Kil Dong4 입니다.', '1234', default, default, default, 17);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd5', '홍길동5', 'Hong Kil Dong5 입니다.', '안녕하세요? Hong Kil Dong5 입니다.', '1234', default, default, default, 18);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd6', '홍길동6', 'Hong Kil Dong6 입니다.', '안녕하세요? Hong Kil Dong6 입니다.', '1234', default, default, default, 19);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd7', '홍길동7', 'Hong Kil Dong7 입니다.', '안녕하세요? Hong Kil Dong71 입니다.', '1234', default, default, default, 20);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd8', '홍길동8', 'Hong Kil Dong8 입니다.', '안녕하세요? Hong Kil Dong8 입니다.', '1234', default, default, default, 21);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd9', '홍길동9', 'Hong Kil Dong9 입니다.', '안녕하세요? Hong Kil Dong9 입니다.', '1234', default, default, default, 22);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd10', '홍길동10', 'Hong Kil Dong10 입니다.', '안녕하세요? Hong Kil Dong10 입니다.', '1234', default, default, default, 23);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg1', '박보검1', '박보검1 입니다.', '안녕하세요? 박보검1 입니다.', '1234', default, default, default, 24);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg2', '박보검2', '박보검2 입니다.', '안녕하세요? 박보검2 입니다.', '1234', default, default, default, 25);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg3', '박보검3', '박보검3 입니다.', '안녕하세요? 박보검3 입니다.', '1234', default, default, default, 26);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg4', '박보검4', '박보검4 입니다.', '안녕하세요? 박보검4 입니다.', '1234', default, default, default, 27);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg5', '박보검5', '박보검5 입니다.', '안녕하세요? 박보검5 입니다.', '1234', default, default, default, 28);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg6', '박보검6', '박보검6 입니다.', '안녕하세요? 박보검6 입니다.', '1234', default, default, default, 29);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg7', '박보검7', '박보검7 입니다.', '안녕하세요? 박보검7 입니다.', '1234', default, default, default, 30);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg8', '박보검8', '박보검8 입니다.', '안녕하세요? 박보검8 입니다.', '1234', default, default, default, 31);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg9', '박보검9', '박보검9 입니다.', '안녕하세요? 박보검9 입니다.', '1234', default, default, default, 32);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg10', '박보검10', '박보검10 입니다.', '안녕하세요? 박보검10 입니다.', '1234', default, default, default, 33);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg1', '박보검1', 'Park Bo Gum1 입니다.', '안녕하세요? Park Bo Gum1 입니다.', '1234', default, default, default, 34);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg2', '박보검2', 'Park Bo Gum2 입니다.', '안녕하세요? Park Bo Gum2 입니다.', '1234', default, default, default, 35);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg3', '박보검3', 'Park Bo Gum3 입니다.', '안녕하세요? Park Bo Gum3 입니다.', '1234', default, default, default, 36);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg4', '박보검4', 'Park Bo Gum4 입니다.', '안녕하세요? Park Bo Gum4 입니다.', '1234', default, default, default, 37);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg5', '박보검5', 'Park Bo Gum5 입니다.', '안녕하세요? Park Bo Gum5 입니다.', '1234', default, default, default, 38);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg6', '박보검6', 'Park Bo Gum6 입니다.', '안녕하세요? Park Bo Gum6 입니다.', '1234', default, default, default, 39);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg7', '박보검7', 'Park Bo Gum7 입니다.', '안녕하세요? Park Bo Gum7 입니다.', '1234', default, default, default, 40);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg8', '박보검8', 'Park Bo Gum8 입니다.', '안녕하세요? Park Bo Gum8 입니다.', '1234', default, default, default, 41);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg9', '박보검9', 'Park Bo Gum9 입니다.', '안녕하세요? Park Bo Gum9 입니다.', '1234', default, default, default, 42);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'parkbg10', '박보검10', 'Park Bo Gum10 입니다.', '안녕하세요? Park Bo Gum10 입니다.', '1234', default, default, default, 43);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd1', '홍길동1', '아버지를 아버지라 부르지1 입니다.', '안녕하세요? 아버지를 아버지라 부르지1 입니다.', '1234', default, default, default, 44);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd2', '홍길동2', '아버지를 아버지라 부르지2 입니다.', '안녕하세요? 아버지를 아버지라 부르지2 입니다.', '1234', default, default, default, 45);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd3', '홍길동3', '아버지를 아버지라 부르지3 입니다.', '안녕하세요? 아버지를 아버지라 부르지3 입니다.', '1234', default, default, default, 46);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd4', '홍길동4', '아버지를 아버지라 부르지4 입니다.', '안녕하세요? 아버지를 아버지라 부르지4 입니다.', '1234', default, default, default, 47);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd5', '홍길동5', '아버지를 아버지라 부르지5 입니다.', '안녕하세요? 아버지를 아버지라 부르지5 입니다.', '1234', default, default, default, 48);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd6', '홍길동6', '아버지를 아버지라 부르지6 입니다.', '안녕하세요? 아버지를 아버지라 부르지6 입니다.', '1234', default, default, default, 49);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd7', '홍길동7', '아버지를 아버지라 부르지7 입니다.', '안녕하세요? 아버지를 아버지라 부르지7 입니다.', '1234', default, default, default, 50);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd8', '홍길동8', '아버지를 아버지라 부르지8 입니다.', '안녕하세요? 아버지를 아버지라 부르지8 입니다.', '1234', default, default, default, 51);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd9', '홍길동9', '아버지를 아버지라 부르지9 입니다.', '안녕하세요? 아버지를 아버지라 부르지9 입니다.', '1234', default, default, default, 52);

insert into spring_tblBoard(seq, userid, name, subject, content, pw, readCount, regDate, status, groupno)
values(spring_boardSeq.nextval, 'hongkd10', '홍길동10', '아버지를 아버지라 부르지10 입니다.', '안녕하세요? 아버지를 아버지라 부르지10 입니다.', '1234', default, default, default, 53);

commit;


select *
from spring_tblBoard
order by seq desc;


select  seq, name, subject, readCount, regDate, commentCount
        , groupno, fk_seq, depthno
from 
	(
	 select rownum as RNO
	        , V.seq, V.name, V.subject, V.content, V.readCount, V.regDate, V.commentCount
                , V.groupno, V.fk_seq, V.depthno
		from 
		(
		   select seq, name 
		          , case when length(subject) > 20 then substr(subject, 1, 18)||'..'
		            else subject end as subject
		         , content , readCount
		         , to_char(regDate, 'yyyy-mm-dd hh24:mi:ss') as regDate
		         , commentCount
                         , groupno, fk_seq, depthno
		   from spring_tblBoard
		   where status = 1
		   -- and subject like '%'|| '아버지' ||'%'
                   start with fk_seq = 0
                   connect by prior seq = fk_seq
		   order siblings by groupno desc, seq asc
		) V
	) T
 where T.RNO >= 1 and T.RNO <= 5;


---------------------------------------------------------------
          ---- *** 파일첨부(업로드 & 다운로드) *** ----
---------------------------------------------------------------
/*
create table spring_tblBoard
(seq           number                not null   -- 글번호
,userid        varchar2(20)          not null   -- 사용자ID
,name          Nvarchar2(20)         not null   -- 글쓴이
,subject       Nvarchar2(200)        not null   -- 글제목
,content       Nvarchar2(2000)       not null   -- 글내용    -- clob
,pw            varchar2(20)          not null   -- 글암호
,readCount     number default 0      not null   -- 글조회수
,regDate       date default sysdate  not null   -- 글쓴시간
,status        number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글 
,commentCount  number default 0      not null   -- 댓글수
,groupno       number                not null   -- 답변글쓰기에 있어서 그룹번호
                                                -- 원글(부모글)과 답변글은 동일한 groupno 를 가진다. 
                                                -- 답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.  
                                                
,fk_seq        number default 0      not null   -- fk_seq 컬럼은 절대로 foreign key가 아니다.
                                                -- fk_seq 컬럼은 자신의 글(답변글)에 있어서 
                                                -- 원글(부모글)이 누구인지에 대한 정보값이다.
                                                -- 답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은 
                                                -- 원글(부모글)의 seq 컬럼의 값을 가지게 되며,
                                                -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.
                                                
,depthno       number default 0       not null  -- 답변글쓰기에 있어서 답변글 이라면                                                
                                                -- 원글(부모글)의 depthno + 1 을 가지게 되며,
                                                -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.

, fileName     varchar2(255)     -- WAS(톰캣)에 저장될 파일명(20161121324325454354353333432.png)
, orgFilename  varchar2(255)   -- 진짜 파일명(강아지.png)   // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
, fileSize     number             -- 파일크기

,constraint  PK_spring_tblBoard_seq primary key(seq)
,constraint  FK_spring_tblBoard_userid foreign key(userid) 
                                       references spring_jsp_member(userid)
,constraint  CK_spring_tblBoard_status check( status in(0,1) )
);
*/

--- *** 컬럼추가 *** ---
alter table spring_tblBoard
add fileName varchar2(255);
-- WAS(톰캣)에 저장될 파일명(20161121324325454354353333432.png)

alter table spring_tblBoard
add orgFilename varchar2(255);
-- 진짜 파일명(강아지.png)   // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명

alter table spring_tblBoard
add fileSize number;
-- 파일크기

fileName, orgFilename, fileSize


select *
from spring_tblBoard
order by seq desc;


select name
from spring_tblBoard
where lower(name) like '%'|| lower('영주') ||'%'
group by name ;


select distinct name
from spring_tblBoard
where lower(name) like '%'|| lower('영주') ||'%'

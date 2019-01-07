# -*- mode: sql -*-

-- GROUP : DT2283GROUP_N

DROP TABLE FinalResults CASCADE CONSTRAINTS PURGE;
DROP TABLE TestAllocated CASCADE CONSTRAINTS PURGE;
DROP TABLE StaffSpeciality CASCADE CONSTRAINTS PURGE;
DROP TABLE TestType CASCADE CONSTRAINTS PURGE;
DROP TABLE Letter CASCADE CONSTRAINTS PURGE;
DROP TABLE Car CASCADE CONSTRAINTS PURGE;
DROP TABLE Owner CASCADE CONSTRAINTS PURGE;
DROP TABLE Staff CASCADE CONSTRAINTS PURGE;
DROP TABLE Center CASCADE CONSTRAINTS PURGE;
--CREATE STATEMENTS

CREATE TABLE Center (
  CenterID  Number(7)  primary key,
  CenterName  VARCHAR2(20) not null,
  CenterStreet  VARCHAR2(20) not null,
  CenterCity  VARCHAR2(20) not null
);

CREATE TABLE Staff (
  StaffEmail  VARCHAR2(64)  PRIMARY KEY,
  SFName  VARCHAR2(30)  NOT NULL ,
  SLName  VARCHAR2(40)  NOT NULL ,
  CenterID NOT NULL REFERENCES Center(CenterID),
  SLastSignedIn DATE NOT NULL,
  SROLE VARCHAR2(30) NOT NULL CHECK (SROLE IN ('mechanic', 'supervisor', 'clerk'))
);

CREATE TABLE Owner(
  OwnerEmail  varchar2(64) PRIMARY KEY,
  OwnerFName  VARCHAR2(30) not null,
  OwnerLName  VARCHAR2(30) not null,
  OwnerStreet VARCHAR2(30),
  OwnerCity VARCHAR2(30)
);

CREATE TABLE Car (
  CarRegNo VARCHAR2(10) PRIMARY KEY,
  CarDescription VARCHAR2(30)  NOT NULL ,
  CarManufacturer  VARCHAR2(30)  NOT NULL ,
  CarDate DATE NOT NULL,
  OwnerEmail NOT NULL REFERENCES Owner(OwnerEmail)
);

CREATE TABLE Letter (
  letterID varchar2(20) PRIMARY KEY check(letterID like '%-%-%:%'),
  letterDate  DATE NOT NULL,
  CenterID NOT NULL REFERENCES Center(CenterID),
  CarRegNo NOT NULL REFERENCES Car(CarRegNo) on delete cascade, -- delete letter associated to car when car is destroyed
  submittedOnDate date -- set to null by default
);

CREATE Table TestType(
  TestTypeID varchar2(20) PRIMARY KEY,
  TestCriticality VARCHAR(10)  NOT NULL CHECK (TestCriticality IN ('high', 'medium', 'low')),
  TestCriticalityFailDesc  VARCHAR(128)  NOT NULL
);

create table StaffSpeciality(
  TestTypeID REFERENCES TestType(TestTypeID) on delete cascade,
  StaffEmail NOT NULL REFERENCES Staff(StaffEmail) on delete cascade,
  Constraint StaffSpeciality_PK primary key(TestTypeID, StaffEmail)
);
CREATE Table TestAllocated(
  letterID NOT NULL references Letter(letterID) on delete cascade,
  TestTypeID NOT NULL references TestType(TestTypeID),
  StaffEmail NOT NULL REFERENCES Staff(StaffEmail) on delete cascade, -- don't allocate to deleted mechanics
  TestComments VARCHAR(256),
  TestStatus  VARCHAR(10) CHECK (TestStatus IN ('fail', 'pass', 'warning')),
  Constraint TestAllocated_PK primary key(TestTypeID,letterID,StaffEmail)
);
create table FinalResults (
  CarRegNo NOT NULL REFERENCES Car(CarRegNo) on delete cascade, -- delete past results of car when car is destroyed.
  Supervisor  NOT NULL REFERENCES Staff(StaffEmail),
  FinalScore  VARCHAR2(20) not null CHECK (FinalScore IN ('fail', 'pass', 'warning')),
  ResultDate TIMESTAMP default CURRENT_DATE,
  Constraint FinalResults_PK primary key(CarRegNo,ResultDate)
);

drop sequence sequence_center;
create sequence sequence_center minvalue 1 start with 1;

commit;



--INSERT STATEMENTS

insert into Center values (sequence_center.nextval,'Central Car Office','Inchicore Rd','Dublin 8');
insert into center values (sequence_center.nextval,'Car Test','City center','Dublin 1');
insert into center values (sequence_center.nextval,'Car City','North South Rd','Dublin 16');



INSERT INTO Staff VALUES ('hlu@staff.ie','Hung','Lu', 1, '17-NOV-2018', 'clerk');
INSERT INTO Staff VALUES ('pperez@staff.ie','Pedro','Perez', 1, '17-OCT-2018', 'clerk');

INSERT INTO Staff VALUES ('jmeyer@staff.ie','Jack','Meyr', 3, '17-NOV-2018', 'supervisor');
INSERT INTO Staff VALUES ('fjackman@staff.ie','Frank','Jackman', 3, '17-NOV-2018', 'mechanic');
INSERT INTO Staff VALUES ('gwider@staff.ie','George','Wilder', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('lconnely@staff.ie','Lucy','Connelly', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('jclarke@staff.ie','James','Clarke', 3, '17-OCT-2018','mechanic');
INSERT INTO Staff VALUES ('abella@staff.ie','Anita','Bella', 3, '17-OCT-2018','mechanic');
INSERT INTO Staff VALUES ('jdassie@staff.ie','Joe','Dassin', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('ffrancois@staff.ie','Frederic','Francois', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('lmartin@staff.ie','Louanne','Martin',3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('fdubois@staff.ie','Francois','Dubois', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('wdamn@staff.ie','Woaw','Damn', 3, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('mjames@staff.ie','Marie','James', 3, '17-NOV-2018','mechanic');

INSERT INTO Staff VALUES ('lchen@staff.ie','Lu','Chen', 2, '17-NOV-2018', 'supervisor');
INSERT INTO Staff VALUES ('psmith@staff.ie','Paul','Smith', 2, '17-NOV-2018' ,'mechanic');
INSERT INTO Staff VALUES ('ddunn@staff.ie','Dan','Dunn', 2, '17-SEP-2018','mechanic');
INSERT INTO Staff VALUES ('mmiller@staff.ie','Misty','Miller', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('rbottom@staff.ie','Rock','Bottom', 2, '16-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('mclark@staff.ie','Maybe','Clark', 2, '17-OCT-2018','mechanic');
INSERT INTO Staff VALUES ('msantry@staff.ie','Martin','Santry', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('lpark@staff.ie','Laura','Park', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('Jlandry@staff.ie','Jordan','Landry', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('wmeda@staff.ie','willie','Meda', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('ccalloo@staff.ie','Carl','Calloo', 2, '17-NOV-2018','mechanic');
INSERT INTO Staff VALUES ('cblack@staff.ie','Cassandra','Black', 2, '17-NOV-2018','mechanic');


insert into TestType VALUES ('Brakes', 'high', 'Takes longer to break and slides at times');
insert into TestType VALUES ('Gearbox','high', 'Gets stuck');
insert into TestType VALUES ('Engine','high', 'Smoke is coming out of it, will it explode?');
insert into TestType VALUES ('Lights','high', 'Turn off unexpectedly, does not work at all');
insert into TestType VALUES ('Mirrors','high', 'Broken, inexistant');
insert into TestType VALUES ('Seat belts','high', 'Absent');
insert into TestType VALUES ('Door locks','medium','hard to open or close the door');
insert into TestType VALUES ('Seat adjust','medium', 'Not cozy enough?');
insert into TestType VALUES ('Outer trim','low','Rust on bottom of door');
insert into TestType VALUES ('Inner trim','low','Covers worn. No head rests');

INSERT INTO Owner VALUES ('mabradley@em.com','Margaret','Bradley','28 Horseshoe Drive','Dublin 8');
INSERT INTO Owner VALUES ('frneyman@em.com','Frank','Neyman','22 Upper Street','Dublin 3');
INSERT INTO Owner VALUES ('lhirscher@em.com','Lucas','Hirscher','23 Lower Street','Dublin 2');
INSERT INTO Owner VALUES ('lhuber@em.com','Lucy','Huber','101 Horseshoe Drive','Dublin 9');

INSERT INTO Car VALUES ('EU-000','Audi A4 1,9 TDI','Audi', '16-NOV-2013','mabradley@em.com');
INSERT INTO Car VALUES ('EU-001','VW Polo','VW', '16-NOV-2013','mabradley@em.com');
INSERT INTO Car VALUES ('EU-002','BMW','BMW', '16-NOV-2013','mabradley@em.com');
INSERT INTO Car VALUES ('US-002','Mazda','MZ', '17-NOV-2013','frneyman@em.com');
INSERT INTO Car VALUES ('IE-000','Suzuki Swift','Suzuki', '10-SEP-2010','lhuber@em.com');


INSERT INTO  LETTER  VALUES ('18-NOV-18:EU-002', '18-NOV-18', 2, 'EU-002',default); -- WILL PASS THE TEST
INSERT INTO  LETTER  VALUES ('18-NOV-18:IE-000', '18-NOV-18', 3, 'IE-000',default); -- WILL FAIL THE TEST ONCE
INSERT INTO  LETTER  VALUES ('18-NOV-18:US-002', '18-NOV-18', 2, 'US-002',default); -- WILL HAVE UNAVAILABLE MECHANIC PRESENT TODAY
INSERT INTO  LETTER  VALUES ('18-NOV-18:EU-001', '18-NOV-18', 3, 'EU-001',default); -- WILL FAIL THE TEST 3 TIMES

-- ENTER TWO FAIL TESTS for latest car
INSERT INTO  LETTER  VALUES ('18-APR-18:EU-001', '18-APR-18', 3, 'EU-001','24-APR-18');
INSERT INTO  LETTER  VALUES ('01-JAN-18:EU-001', '01-JAN-18', 3, 'EU-001','19-JAN-18');

-- MARK THESE AS FAIL
INSERT INTO  FinalResults  VALUES ('EU-001', 'jmeyer@staff.ie','fail', '25-APR-18');
INSERT INTO  FinalResults  VALUES ('EU-001', 'jmeyer@staff.ie','fail', '18-JAN-18');

-- SUBMIT FEW LETTERS
update Letter set
SubmittedOnDate = sysdate
where CarRegNo IN ('EU-002', 'EU-001', 'US-002', 'IE-000') and SubmittedOnDate is null;

-- assign specialities to Mechanics at random

declare
  counter number; -- a random number of Test to assign to a mechanic
  TestType_count number; -- the total number of specialities available
begin
  select count(*) into TestType_count from TestType; -- get all Test available
  for mechanic in (select StaffEmail from Staff where SROLE='mechanic') loop -- get all mechanic email
     -- every mechanic will have minimum one skill, thus random from 1 to the tol number
     counter := ceil(dbms_random.value(1, TestType_count));
     -- shuffle the Type table so that the skills will be uniform
     for t in (select distinct TestTypeID from TestType ORDER BY dbms_random.value) loop
        if counter > 0 then
           begin
              insert into StaffSpeciality values (t.TestTypeID, mechanic.StaffEmail);
           end;
           counter := counter -1;
        else
           exit; -- exit if counter random specialities have been assigned to current mechanic
        end if; -- end insertion
     end loop; -- end assigning speciality
  end loop;   -- end looping through mechanics
  commit;
  exception
  when others then
  rollback;
  raise;
end;
commit;
-- end assigning mechanics to speciality transaction

grant ALL PRIVILEGES on Center to jfahringer, czhang, tzihindula; --all

grant ALL PRIVILEGES on Staff to jfahringer, czhang, tzihindula; --all

grant ALL PRIVILEGES on Car to jfahringer, czhang, tzihindula; -- all

grant ALL PRIVILEGES on Owner to jfahringer, czhang, tzihindula; -- all

grant ALL PRIVILEGES on Letter to jfahringer, czhang, tzihindula; -- all

grant ALL PRIVILEGES on sequence_center to czhang; -- only clerk needs to add a center etc.

grant select on StaffSpeciality to jfahringer, czhang, tzihindula; -- everyone can check what who is specialised in

grant ALL PRIVILEGES on TestAllocated to jfahringer, tzihindula; -- only supervisor and mechanic can edit this

grant select on TestType to jfahringer,czhang, tzihindula; -- eveyone can view what testtypes are there

grant select on FinalResults to jfahringer, czhang; --clerk and mechanics can only view

grant ALL PRIVILEGES on FinalResults to tzihindula; --Supervisor can update this table

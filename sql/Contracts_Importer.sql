DROP TABLE IF EXISTS api;
DROP TABLE IF EXISTS api.contracts;
DROP OWNED BY web_anon;
DROP USER web_anon;


CREATE SCHEMA api;

CREATE TABLE api.contracts (
	ContractID VARCHAR(100),
	PlanID VARCHAR(100),
	OrganizationType VARCHAR(100),
	PlanType VARCHAR(100),
	OffersPartD BOOL,
	SNPPlan BOOL,
	EGHP VARCHAR(100),
	OrganizationName VARCHAR(100),
	OrganizationMarketingName VARCHAR(100),
	PlanName VARCHAR(100),
	ParentOrganization VARCHAR(100),
	ContractEffectiveDate VARCHAR(100));

CREATE TABLE api.enrollments (
	contractid text,
	planid text,
	ssa VARCHAR(20),
	fips VARCHAR(20),
	state VARCHAR(2),
	county VARCHAR(100),
	enrolled TEXT );

COPY "2022_10" (contractid, planid, ssa, fips, state, county, enrolled)
FROM 'J:\medicare\csv_big\CPSC_enrolled_Info_2022_10.csv'
DELIMITER ','
CSV HEADER;

create role web_anon nologin;

grant usage on schema api to web_anon;
grant select on api.contracts to web_anon;

\COPY api.contracts
FROM '/home/MedicareAPI/PostgREST/CPSC_Contract_Info_2024_07.csv'
WITH DELIMITER ','
CSV HEADER;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;



ALTER TABLE "Contracts" ADD COLUMN "ID" text ;

UPDATE "Contracts" SET "ID" = ContractID || '' || PlanID;

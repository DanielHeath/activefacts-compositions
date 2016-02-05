CREATE TABLE Company (
	-- Company has Company Name
	CompanyName                             varchar NULL,
	-- maybe Company has head office at Address that maybe is at street-Number
	AddressStreetNumber                     varchar(12) NOT NULL,
	-- maybe Company has head office at Address that is at Street that includes first-Street Line
	AddressStreetFirstStreetLine            varchar(64) NOT NULL,
	-- maybe Company has head office at Address that is at Street that maybe includes second-Street Line
	AddressStreetSecondStreetLine           varchar(64) NOT NULL,
	-- maybe Company has head office at Address that is at Street that maybe includes third-Street Line
	AddressStreetThirdStreetLine            varchar(64) NOT NULL,
	-- maybe Company has head office at Address that is in City
	AddressCity                             varchar(64) NOT NULL,
	-- maybe Company has head office at Address that maybe is in Postcode
	AddressPostcode                         varchar NOT NULL CHECK((AddressPostcode >= 1000 AND AddressPostcode <= 9999)),
	-- Primary index to Company over PresenceConstraint over (Company Name in "Company has Company Name") occurs at most one time
	PRIMARY KEY CLUSTERED(CompanyName)
)
GO

CREATE TABLE Person (
	-- Person is of Family that has Family Name
	FamilyName                              varchar(20) NULL,
	-- Person has Given Names
	GivenNames                              varchar(20) NULL,
	-- maybe Person lives at Address that maybe is at street-Number
	AddressStreetNumber                     varchar(12) NOT NULL,
	-- maybe Person lives at Address that is at Street that includes first-Street Line
	AddressStreetFirstStreetLine            varchar(64) NOT NULL,
	-- maybe Person lives at Address that is at Street that maybe includes second-Street Line
	AddressStreetSecondStreetLine           varchar(64) NOT NULL,
	-- maybe Person lives at Address that is at Street that maybe includes third-Street Line
	AddressStreetThirdStreetLine            varchar(64) NOT NULL,
	-- maybe Person lives at Address that is in City
	AddressCity                             varchar(64) NOT NULL,
	-- maybe Person lives at Address that maybe is in Postcode
	AddressPostcode                         varchar NOT NULL CHECK((AddressPostcode >= 1000 AND AddressPostcode <= 9999)),
	-- Primary index to Person over PresenceConstraint over (Family, Given Names in "Person is of Family", "Person has Given Names") occurs at most one time
	PRIMARY KEY CLUSTERED(FamilyName, GivenNames)
)
GO


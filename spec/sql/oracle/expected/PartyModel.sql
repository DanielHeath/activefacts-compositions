CREATE TABLE COMPANY (
	-- Company is a kind of Party that has Party ID
	PARTY_ID                                LONGINTEGER NOT NULL,
	-- Primary index to Company over PresenceConstraint over (Party in "Company is a kind of Party") occurs at most one time
	PRIMARY KEY(PARTY_ID)
);


CREATE TABLE PARTY (
	-- Party has Party ID
	PARTY_ID                                LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Party is of Party Type that has Party Type Code
	PARTY_TYPE_CODE                         VARCHAR(16) NOT NULL CHECK(PARTY_TYPE_CODE = 'Company' OR PARTY_TYPE_CODE = 'Person'),
	-- Primary index to Party over PresenceConstraint over (Party ID in "Party has Party ID") occurs at most one time
	PRIMARY KEY(PARTY_ID)
);


CREATE TABLE PERSON (
	-- Person is a kind of Party that has Party ID
	PARTY_ID                                LONGINTEGER NOT NULL,
	-- Primary index to Person over PresenceConstraint over (Party in "Person is a kind of Party") occurs at most one time
	PRIMARY KEY(PARTY_ID),
	FOREIGN KEY (PARTY_ID) REFERENCES PARTY (PARTY_ID)
);


ALTER TABLE COMPANY
	ADD FOREIGN KEY (PARTY_ID) REFERENCES PARTY (PARTY_ID);


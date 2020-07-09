ALTER TABLE AM_WORKFLOWS ADD
 WF_METADATA VARBINARY(MAX) NULL DEFAULT NULL,
 WF_PROPERTIES VARBINARY(MAX) NULL DEFAULT NULL
;

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_GW_PUBLISHED_API_DETAILS]') AND TYPE IN (N'U'))
CREATE TABLE  AM_GW_PUBLISHED_API_DETAILS (
  API_ID varchar(255) NOT NULL,
  TENANT_DOMAIN varchar(255),
  API_PROVIDER varchar(255),
  API_NAME varchar(255),
  API_VERSION varchar(255),
  PRIMARY KEY (API_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_GW_API_ARTIFACTS]') AND TYPE IN (N'U'))
CREATE TABLE  AM_GW_API_ARTIFACTS (
  API_ID varchar(255) NOT NULL,
  ARTIFACT VARBINARY(MAX),
  GATEWAY_INSTRUCTION varchar(20),
  GATEWAY_LABEL varchar(255),
  TIMESTAMP DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (GATEWAY_LABEL, API_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_GW_PUBLISHED_API_DETAILS(API_ID) ON UPDATE CASCADE ON DELETE NO ACTION
);

GO
CREATE TRIGGER dbo.TIMESTAMP ON dbo.AM_GW_API_ARTIFACTS
AFTER INSERT, UPDATE
AS
  UPDATE f set TIMESTAMP=GETDATE()
  FROM
  dbo.[AM_GW_API_ARTIFACTSFG] AS f
  INNER JOIN inserted
  AS i
  ON f.TIMESTAMP = i.TIMESTAMP;
GO

ALTER TABLE AM_SUBSCRIPTION ADD TIER_ID_PENDING VARCHAR(50);

ALTER TABLE AM_POLICY_SUBSCRIPTION ADD
  MAX_COMPLEXITY INTEGER NOT NULL DEFAULT 0,
  MAX_DEPTH INTEGER NOT NULL DEFAULT 0
;

CREATE TABLE IF NOT EXISTS AM_API_RESOURCE_SCOPE_MAPPING (
    SCOPE_NAME VARCHAR(255) NOT NULL,
    URL_MAPPING_ID INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    FOREIGN KEY (URL_MAPPING_ID) REFERENCES   AM_API_URL_MAPPING(URL_MAPPING_ID) ON DELETE CASCADE,
    PRIMARY KEY(SCOPE_NAME, URL_MAPPING_ID)
);


CREATE TABLE IF NOT EXISTS AM_SHARED_SCOPE (
     NAME VARCHAR(255),
     UUID VARCHAR (256),
     TENANT_ID INTEGER,
     PRIMARY KEY (UUID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_KEY_MANAGER]') AND TYPE IN (N'U'))
CREATE TABLE AM_KEY_MANAGER (
  UUID VARCHAR(50) NOT NULL,
  NAME VARCHAR(100) NULL,
  DISPLAY_NAME VARCHAR(100) NULL,
  DESCRIPTION VARCHAR(256) NULL,
  TYPE VARCHAR(45) NULL,
  CONFIGURATION VARBINARY(MAX) NULL,
  ENABLED BIT DEFAULT 1,
  TENANT_DOMAIN VARCHAR(100) NULL,
  PRIMARY KEY (UUID),
  UNIQUE (NAME,TENANT_DOMAIN)
  );

IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_TENANT_THEMES]') AND TYPE IN (N'U'))
CREATE TABLE AM_TENANT_THEMES (
  TENANT_ID INTEGER NOT NULL,
  THEME VARBINARY(MAX) NOT NULL,
  PRIMARY KEY (TENANT_ID)
);
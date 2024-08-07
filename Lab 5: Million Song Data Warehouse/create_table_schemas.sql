CREATE OR REPLACE STAGE TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN
    STORAGE_INTEGRATION = s3_int
    URL='s3://techcatalyst-public/dw_stage/kaitlyn';
    

CREATE OR REPLACE FILE FORMAT KBORSKI.KB_parquet_format
    TYPE = 'PARQUET';

 
CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.KBORSKI.SONGS_DIM (
    SONG_ID STRING,
    TITLE STRING,
    ARTIST_ID STRING,
    YEAR INTEGER,
    DURATION NUMBER(10,5)
);
COPY INTO TECHCATALYST_DE.KBORSKI.SONGS_DIM
FROM @TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN/songs/
    PATTERN = '.*parquet.*'
    FILE_FORMAT = (FORMAT_NAME = KBORSKI.KB_parquet_format)
    ON_ERROR = CONTINUE
    MATCH_BY_COLUMN_NAME= CASE_INSENSITIVE;

SELECT * FROM TECHCATALYST_DE.KBORSKI.SONGS_DIM;



CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.KBORSKI.USER_DIM (
    ID STRING,
    FIRSTNAME STRING,
    LASTNAME STRING,
    GENDER STRING,
    LEVEL STRING
);
COPY INTO TECHCATALYST_DE.KBORSKI.USER_DIM
FROM @TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN/users/
    FILE_FORMAT = 'KBORSKI.KB_parquet_format'
    ON_ERROR = CONTINUE
    MATCH_BY_COLUMN_NAME= CASE_INSENSITIVE;

SELECT * FROM TECHCATALYST_DE.KBORSKI.USER_DIM;


CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.KBORSKI.TIME_DIM (
    TS BIGINT,
    DATETIME STRING,
    START_TIME STRING,
    "YEAR" STRING,
    "MONTH" STRING,
    "DAYOFMONTH" INTEGER,
    "WEEKOFYEAR" INTEGER
);
COPY INTO TECHCATALYST_DE.KBORSKI.TIME_DIM
FROM @TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN/time/
    FILE_FORMAT =('PARQUET')
    ON_ERROR = CONTINUE
    MATCH_BY_COLUMN_NAME= CASE_INSENSITIVE;

SELECT * FROM TECHCATALYST_DE.KBORSKI.TIME_DIM;


CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.KBORSKI.ARTIST_DIM (
    ARTIST_ID STRING,
    ARTIST_NAME STRING,
    ARTIST_LOCATION STRING,
    ARTIST_LATITUDE NUMBER(10,5),
    ARTIST_LONGITUDE NUMBER(10,5)
);
COPY INTO TECHCATALYST_DE.KBORSKI.ARTIST_DIM
FROM @TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN/artists/
    FILE_FORMAT = (FORMAT_NAME = KBORSKI.KB_parquet_format)
    ON_ERROR = CONTINUE
    MATCH_BY_COLUMN_NAME= CASE_INSENSITIVE;

SELECT * FROM TECHCATALYST_DE.KBORSKI.ARTIST_DIM;


CREATE OR REPLACE TRANSIENT TABLE TECHCATALYST_DE.KBORSKI.SONGPLAYS_FACT (
    SONGPLAY_ID INTEGER,
    DATETIME_ID BIGINT,
    USER_ID STRING,
    LEVEL STRING,
    SONG_ID STRING,
    ARTIST_ID STRING,
    SESSION_ID BIGINT,
    LOCATION STRING,
    USER_AGENT STRING
);
COPY INTO TECHCATALYST_DE.KBORSKI.SONGPLAYS_FACT
FROM @TECHCATALYST_DE.EXTERNAL_STAGE.KAITLYN/songplays/
    FILE_FORMAT = (FORMAT_NAME = KBORSKI.KB_parquet_format)
    ON_ERROR = CONTINUE
    MATCH_BY_COLUMN_NAME= CASE_INSENSITIVE;

SELECT * FROM TECHCATALYST_DE.KBORSKI.SONGPLAYS_FACT;
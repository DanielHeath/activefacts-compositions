CREATE TABLE AUTHOR (
	-- Author has Author Id
	AUTHOR_ID                               LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Author is called Name
	AUTHOR_NAME                             VARCHAR(64) NOT NULL,
	-- Primary index to Author(Author Id in "Author has Author Id")
	PRIMARY KEY(AUTHOR_ID),
	-- Unique index to Author(Author Name in "author-Name is of Author")
	UNIQUE(AUTHOR_NAME)
);


CREATE TABLE "COMMENT" (
	-- Comment has Comment Id
	COMMENT_ID                              LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Comment was written by Author that has Author Id
	AUTHOR_ID                               LONGINTEGER NOT NULL,
	-- Comment consists of text-Content and maybe Content is of Style
	CONTENT_STYLE                           VARCHAR(20) NULL,
	-- Comment consists of text-Content and Content has Text
	CONTENT_TEXT                            VARCHAR(MAX) NOT NULL,
	-- Comment is on Paragraph that involves Post that has Post Id
	PARAGRAPH_POST_ID                       LONGINTEGER NOT NULL,
	-- Comment is on Paragraph that involves Ordinal
	PARAGRAPH_ORDINAL                       INTEGER NOT NULL,
	-- Primary index to Comment(Comment Id in "Comment has Comment Id")
	PRIMARY KEY(COMMENT_ID),
	FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHOR (AUTHOR_ID)
);


CREATE TABLE PARAGRAPH (
	-- Paragraph involves Post that has Post Id
	POST_ID                                 LONGINTEGER NOT NULL,
	-- Paragraph involves Ordinal
	ORDINAL                                 INTEGER NOT NULL,
	-- Paragraph contains Content that maybe is of Style
	CONTENT_STYLE                           VARCHAR(20) NULL,
	-- Paragraph contains Content that has Text
	CONTENT_TEXT                            VARCHAR(MAX) NOT NULL,
	-- Primary index to Paragraph(Post, Ordinal in "Post includes Ordinal paragraph")
	PRIMARY KEY(POST_ID, ORDINAL)
);


CREATE TABLE POST (
	-- Post has Post Id
	POST_ID                                 LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Post was written by Author that has Author Id
	AUTHOR_ID                               LONGINTEGER NOT NULL,
	-- Post belongs to Topic that has Topic Id
	TOPIC_ID                                LONGINTEGER NOT NULL,
	-- Primary index to Post(Post Id in "Post has Post Id")
	PRIMARY KEY(POST_ID),
	FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHOR (AUTHOR_ID)
);


CREATE TABLE TOPIC (
	-- Topic has Topic Id
	TOPIC_ID                                LONGINTEGER NOT NULL GENERATED BY DEFAULT ON NULL AS IDENTITY,
	-- Topic is called topic-Name
	TOPIC_NAME                              VARCHAR(64) NOT NULL,
	-- maybe Topic belongs to parent-Topic and Topic has Topic Id
	PARENT_TOPIC_ID                         LONGINTEGER NULL,
	-- Primary index to Topic(Topic Id in "Topic has Topic Id")
	PRIMARY KEY(TOPIC_ID),
	-- Unique index to Topic(Topic Name in "Topic is called topic-Name")
	UNIQUE(TOPIC_NAME),
	FOREIGN KEY (PARENT_TOPIC_ID) REFERENCES TOPIC (TOPIC_ID)
);


ALTER TABLE "COMMENT"
	ADD FOREIGN KEY (PARAGRAPH_POST_ID, PARAGRAPH_ORDINAL) REFERENCES PARAGRAPH (POST_ID, ORDINAL);

ALTER TABLE PARAGRAPH
	ADD FOREIGN KEY (POST_ID) REFERENCES POST (POST_ID);

ALTER TABLE POST
	ADD FOREIGN KEY (TOPIC_ID) REFERENCES TOPIC (TOPIC_ID);

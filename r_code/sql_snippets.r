snippet tbl
	create table ${1:table} (
		${2:columns}
	);
snippet col
	${1:name}	${2:type}	${3:default ''}	${4:not null}
snippet ccol
	${1:name}	varchar2(${2:size})	${3:default ''}	${4:not null}
snippet ncol
	${1:name}	number	${3:default 0}	${4:not null}
snippet dcol
	${1:name}	date	${3:default sysdate}	${4:not null}
snippet ind
	create index ${3:$1_$2} on ${1:table}(${2:column});
snippet uind
	create unique index ${1:name} on ${2:table}(${3:column});
snippet tblcom
	comment on table ${1:table} is '${2:comment}';
snippet colcom
	comment on column ${1:table}.${2:column} is '${3:comment}';
snippet addcol
	alter table ${1:table} add (${2:column} ${3:type});
snippet seq
	create sequence ${1:name} start with ${2:1} increment by ${3:1} minvalue ${4:1};
snippet s*
	select * from ${1:table}

snippet sqlsnip
	-- ============================================================
	-- Databricks SQL Canonical Snippet Reference
	-- (Type snippet name + <Tab> to expand)
	-- ============================================================
	
	-- A) Temp view workflow
	-- tv       : CREATE OR REPLACE TEMPORARY VIEW ... AS SELECT *
	-- tvq      : Temp view with SELECT / FROM / WHERE scaffold
	-- tvcte    : Temp view wrapping a WITH (CTE) expression
	-- tvn      : "Next step" temp view selecting from prior view
	-- dropv    : DROP VIEW IF EXISTS
	
	-- B) Query scaffolds
	-- sf       : SELECT * FROM source
	-- sfd      : SELECT DISTINCT * FROM source
	-- sfw      : SELECT / FROM / WHERE
	-- sfwo     : SELECT / FROM / WHERE / ORDER BY
	-- sfwg     : SELECT / FROM / WHERE / GROUP BY (with aggregation)
	-- sfwgh    : SELECT / FROM / WHERE / GROUP BY / HAVING
	-- sfwgo    : SELECT / FROM / WHERE / GROUP BY / ORDER BY
	
	-- C) Join scaffolds (single join)
	-- sfl      : SELECT with LEFT JOIN
	-- sflw     : LEFT JOIN with WHERE
	-- sflwg    : LEFT JOIN with WHERE and GROUP BY
	-- sfi      : SELECT with INNER JOIN
	-- sfiw     : INNER JOIN with WHERE
	-- sfiwg    : INNER JOIN with WHERE and GROUP BY
	-- sfu      : FULL OUTER JOIN
	-- sfuw     : FULL OUTER JOIN with WHERE
	
	-- D) CTE helpers
	-- cte      : Single WITH (...) SELECT scaffold
	-- ctes     : Two-stage CTE chain
	
	-- E) Windowing / deduplication
	-- win      : Generic window function (OVER partition/order)
	-- rn       : ROW_NUMBER() window expression
	-- qual     : QUALIFY clause for window filtering
	-- dedup    : Keep latest row per key using ROW_NUMBER
	
	-- F) Transform atoms
	-- case     : CASE WHEN ... THEN ... ELSE ... END
	-- co       : COALESCE(expr, default)
	-- cast     : CAST(expr AS type)
	-- like     : LIKE '%pattern%'
	-- in       : IN (value_list)
	-- nullsafe : Null-safe equality comparison
	-- between  : BETWEEN low AND high
	
	-- G) Debug / sanity checks
	-- lim      : LIMIT n
	-- cnt      : COUNT(*) from source
	-- cntg     : COUNT(*) by group
	-- dups     : Find duplicate keys
	
	-- H) Optional object / Delta helpers
	-- ctas     : CREATE TABLE AS SELECT
	-- tempv    : CREATE TEMP VIEW AS SELECT
	-- merge    : Delta MERGE INTO scaffold
	
	-- U1) Temporary function
	-- fnt			: Temporary (session) scalar SQL function


# ============================
# Databricks SQL - Canonical Snippets (RStudio)
# Paste into: Tools -> Global Options -> Code -> Edit Snippets -> (SQL)
# ============================

# ----------------------------
# A) Temp view workflow
# ----------------------------

snippet tv
	CREATE OR REPLACE TEMPORARY VIEW ${1:view_name} AS
	SELECT
		*
	FROM ${2:source}

snippet tvq
	CREATE OR REPLACE TEMPORARY VIEW ${1:view_name} AS
	SELECT
		${2:select_list}
	FROM ${3:source} ${4:alias}
	WHERE ${5:condition}

snippet tvcte
	CREATE OR REPLACE TEMPORARY VIEW ${1:view_name} AS
	WITH ${2:cte_name} AS (
		SELECT
			*
		FROM ${3:source}
		WHERE ${4:condition}
	)
	SELECT
		*
	FROM ${2:cte_name}

snippet tvn
	CREATE OR REPLACE TEMPORARY VIEW ${1:next_view} AS
	SELECT
		${2:*}
	FROM ${3:prev_view}

snippet dropv
	DROP VIEW IF EXISTS ${1:view_name}

# ----------------------------
# B) Query scaffolds
# ----------------------------

snippet sf
	SELECT
		*
	FROM ${1:source}

snippet sfd
	SELECT DISTINCT
		*
	FROM ${1:source}

snippet sfw
	SELECT
		*
	FROM ${1:source}
	WHERE ${2:condition}

snippet sfwo
	SELECT
		*
	FROM ${1:source}
	WHERE ${2:condition}
	ORDER BY ${3:sort_expr}

snippet sfwg
	SELECT
		${1:group_col},
		${2:agg_expr} AS ${3:alias}
	FROM ${4:source}
	WHERE ${5:condition}
	GROUP BY ${1:group_col}

snippet sfwgh
	SELECT
		${1:group_col},
		${2:agg_expr} AS ${3:alias}
	FROM ${4:source}
	WHERE ${5:condition}
	GROUP BY ${1:group_col}
	HAVING ${6:having_condition}

snippet sfwgo
	SELECT
		${1:group_col},
		${2:agg_expr} AS ${3:alias}
	FROM ${4:source}
	WHERE ${5:condition}
	GROUP BY ${1:group_col}
	ORDER BY ${3:alias} ${6:DESC}

# ----------------------------
# C) Join scaffolds (single join)
# ----------------------------

snippet sfl
	SELECT
		*
	FROM ${1:left_source} l
	LEFT JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}

snippet sflw
	SELECT
		*
	FROM ${1:left_source} l
	LEFT JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}
	WHERE ${5:condition}

snippet sflwg
	SELECT
		${1:l.group_col},
		${2:agg_expr} AS ${3:alias}
	FROM ${4:left_source} l
	LEFT JOIN ${5:right_source} r
		ON ${6:l.key} = ${7:r.key}
	WHERE ${8:condition}
	GROUP BY ${1:l.group_col}

snippet sfi
	SELECT
		*
	FROM ${1:left_source} l
	INNER JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}

snippet sfiw
	SELECT
		*
	FROM ${1:left_source} l
	INNER JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}
	WHERE ${5:condition}

snippet sfiwg
	SELECT
		${1:l.group_col},
		${2:agg_expr} AS ${3:alias}
	FROM ${4:left_source} l
	INNER JOIN ${5:right_source} r
		ON ${6:l.key} = ${7:r.key}
	WHERE ${8:condition}
	GROUP BY ${1:l.group_col}

snippet sfu
	SELECT
		*
	FROM ${1:left_source} l
	FULL OUTER JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}

snippet sfuw
	SELECT
		*
	FROM ${1:left_source} l
	FULL OUTER JOIN ${2:right_source} r
		ON ${3:l.key} = ${4:r.key}
	WHERE ${5:condition}

# ----------------------------
# D) CTE helpers
# ----------------------------

snippet cte
	WITH ${1:cte_name} AS (
		SELECT
			*
		FROM ${2:source}
		WHERE ${3:condition}
	)
	SELECT
		*
	FROM ${1:cte_name}

snippet ctes
	WITH ${1:cte1} AS (
		SELECT
			*
		FROM ${2:source1}
		WHERE ${3:condition1}
	),
	${4:cte2} AS (
		SELECT
			*
		FROM ${1:cte1}
		WHERE ${5:condition2}
	)
	SELECT
		*
	FROM ${4:cte2}

# ----------------------------
# E) Windowing / dedupe
# ----------------------------

snippet win
	${1:func}(${2:expr}) OVER (
		PARTITION BY ${3:partition_cols}
		ORDER BY ${4:order_cols}
	) AS ${5:alias}

snippet rn
	ROW_NUMBER() OVER (
		PARTITION BY ${1:partition_cols}
		ORDER BY ${2:order_cols}
	) AS ${3:rn}

snippet qual
	QUALIFY ${1:window_predicate}

snippet dedup
	WITH base AS (
		SELECT
			*,
			ROW_NUMBER() OVER (
				PARTITION BY ${1:key_cols}
				ORDER BY ${2:order_cols} DESC
			) AS rn
		FROM ${3:source}
	)
	SELECT *
	FROM base
	WHERE rn = 1

# ----------------------------
# F) Transform "atoms"
# ----------------------------

snippet case
	CASE
		WHEN ${1:condition} THEN ${2:value}
		ELSE ${3:else_value}
	END

snippet co
	COALESCE(${1:expr}, ${2:default})

snippet cast
	CAST(${1:expr} AS ${2:type})

snippet like
	${1:expr} LIKE ${2:'%pattern%'}

snippet in
	${1:expr} IN (${2:value_list})

snippet nullsafe
	((${1:a} = ${2:b}) OR (${1:a} IS NULL AND ${2:b} IS NULL))

snippet between
	${1:expr} BETWEEN ${2:low} AND ${3:high}

# ----------------------------
# G) Debug / sanity checks
# ----------------------------

snippet lim
	LIMIT ${1:100}

snippet cnt
	SELECT
		COUNT(*) AS n
	FROM ${1:source}

snippet cntg
	SELECT
		${1:group_col},
		COUNT(*) AS n
	FROM ${2:source}
	GROUP BY ${1:group_col}
	ORDER BY n DESC

snippet dups
	SELECT
		${1:key_cols},
		COUNT(*) AS n
	FROM ${2:source}
	GROUP BY ${1:key_cols}
	HAVING COUNT(*) > 1
	ORDER BY n DESC

# ----------------------------
# H) (Optional) Delta / object creation helpers
# Keep if you sometimes use them; delete if not.
# ----------------------------

snippet ctas
	CREATE OR REPLACE TABLE ${1:table_name} AS
	SELECT
		*
	FROM ${2:source}

snippet tempv
	CREATE OR REPLACE TEMP VIEW ${1:view_name} AS
	SELECT
		*
	FROM ${2:source}

snippet merge
	MERGE INTO ${1:target} t
	USING ${2:source} s
	ON ${3:t.key} = ${4:s.key}
	WHEN MATCHED THEN UPDATE SET
		${5:col} = ${6:s.col}
	WHEN NOT MATCHED THEN INSERT (${7:cols})
	VALUES (${8:values})



# ----------------------------
# U1) Temporary (session) scalar SQL function (most common for ad-hoc)
# ----------------------------

snippet fnt
	CREATE OR REPLACE TEMPORARY FUNCTION ${1:fn_name}(
		${2:arg_name} ${3:arg_type}
	)
	RETURNS ${4:return_type}
	RETURN ${5:expression};



snippet tg_claim
	data_tp1.gold.d_claim_vw AS claim

snippet tg_claim_v
	dk_claim,
	`Claim Number`,
	`Accident Date`,
	`Claim Creation Date`,
	`Claim Type`,
	`Mental Injury Only`

snippet tg_claim_va
	claim.dk_claim,
	claim.`Claim Number`,
	claim.`Accident Date`,
	claim.`Claim Creation Date`,
	claim.`Claim Type`,
	claim.`Mental Injury Only`

snippet tg_claim_c
	claim AS (
		SELECT
			dk_claim,
			`Claim Number`,
			`Accident Date`,
			`Claim Creation Date`,
			`Claim Type`,
			`Mental Injury Only`
		FROM data_tp1.gold.d_claim_vw
	)

snippet tg_claim_cw
	WITH claim AS (
		SELECT
			dk_claim,
			`Claim Number`,
			`Accident Date`,
			`Claim Creation Date`,
			`Claim Type`,
			`Mental Injury Only`
		FROM data_tp1.gold.d_claim_vw
	)



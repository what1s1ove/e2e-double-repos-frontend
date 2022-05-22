--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: binary_storage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA binary_storage;


ALTER SCHEMA binary_storage OWNER TO postgres;

--
-- Name: entity_access_management; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA entity_access_management;


ALTER SCHEMA entity_access_management OWNER TO postgres;

--
-- Name: server_computing; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA server_computing;


ALTER SCHEMA server_computing OWNER TO postgres;

--
-- Name: serverless_computing; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA serverless_computing;


ALTER SCHEMA serverless_computing OWNER TO postgres;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: objects; Type: TABLE; Schema: binary_storage; Owner: postgres
--

CREATE TABLE binary_storage.objects (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(20) NOT NULL,
    size_in_bytes integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    space_id uuid NOT NULL,
    uploaded_by uuid NOT NULL,
    aws_object_key character varying(255) NOT NULL
);


ALTER TABLE binary_storage.objects OWNER TO postgres;

--
-- Name: spaces; Type: TABLE; Schema: binary_storage; Owner: postgres
--

CREATE TABLE binary_storage.spaces (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    created_by uuid NOT NULL,
    aws_s3_id character varying(255) NOT NULL
);


ALTER TABLE binary_storage.spaces OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    tenant_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.groups OWNER TO postgres;

--
-- Name: groups_permissions; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.groups_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    group_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.groups_permissions OWNER TO postgres;

--
-- Name: masters; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.masters (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    password_salt text NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL,
    tenant_id uuid NOT NULL
);


ALTER TABLE entity_access_management.masters OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.permissions OWNER TO postgres;

--
-- Name: tenants; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.tenants (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.tenants OWNER TO postgres;

--
-- Name: users_groups; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.users_groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    group_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.users_groups OWNER TO postgres;

--
-- Name: workers; Type: TABLE; Schema: entity_access_management; Owner: postgres
--

CREATE TABLE entity_access_management.workers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    password_hash text NOT NULL,
    password_salt text NOT NULL,
    tenant_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-02-09 19:06:06+02'::timestamp with time zone NOT NULL
);


ALTER TABLE entity_access_management.workers OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: migrations_lock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.migrations_lock OWNER TO postgres;

--
-- Name: migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_lock_index_seq OWNER TO postgres;

--
-- Name: migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_lock_index_seq OWNED BY public.migrations_lock.index;


--
-- Name: instances; Type: TABLE; Schema: server_computing; Owner: postgres
--

CREATE TABLE server_computing.instances (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-03-01 12:08:41+02'::timestamp with time zone NOT NULL,
    key_pair_id uuid,
    username character varying(255) NOT NULL,
    hostname character varying(255) NOT NULL,
    operation_system_id uuid,
    created_by uuid,
    aws_instance_id character varying(255) NOT NULL,
    tenant_id uuid NOT NULL
);


ALTER TABLE server_computing.instances OWNER TO postgres;

--
-- Name: key_pairs; Type: TABLE; Schema: server_computing; Owner: postgres
--

CREATE TABLE server_computing.key_pairs (
    id uuid NOT NULL,
    ssh_pem_file_content text NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-03-01 12:08:41+02'::timestamp with time zone NOT NULL
);


ALTER TABLE server_computing.key_pairs OWNER TO postgres;

--
-- Name: operation_systems; Type: TABLE; Schema: server_computing; Owner: postgres
--

CREATE TABLE server_computing.operation_systems (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-03-01 12:08:41+02'::timestamp with time zone NOT NULL,
    aws_generation_name character varying(255) NOT NULL
);


ALTER TABLE server_computing.operation_systems OWNER TO postgres;

--
-- Name: functions; Type: TABLE; Schema: serverless_computing; Owner: postgres
--

CREATE TABLE serverless_computing.functions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT '2022-03-01 12:08:41+02'::timestamp with time zone NOT NULL,
    source_code text NOT NULL,
    created_by uuid NOT NULL,
    aws_lambda_id character varying(255) NOT NULL,
    updated_at timestamp with time zone DEFAULT '2022-03-01 12:08:41+02'::timestamp with time zone NOT NULL
);


ALTER TABLE serverless_computing.functions OWNER TO postgres;

--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: migrations_lock index; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.migrations_lock_index_seq'::regclass);


--
-- Data for Name: objects; Type: TABLE DATA; Schema: binary_storage; Owner: postgres
--

COPY binary_storage.objects (id, name, size_in_bytes, created_at, space_id, uploaded_by, aws_object_key) FROM stdin;
\.


--
-- Data for Name: spaces; Type: TABLE DATA; Schema: binary_storage; Owner: postgres
--

COPY binary_storage.spaces (id, name, created_at, created_by, aws_s3_id) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.groups (id, name, tenant_id, created_at) FROM stdin;
d192081a-f71a-47b8-870a-0e397750e333	admins	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-03-01 12:17:44+02
cc507ba7-c409-44a2-b718-6a4a4de708f4	admins	5890341b-33ee-4405-b99c-9879152b7d46	2022-04-09 12:01:25+03
557d7562-f607-4216-bc54-02e9b7efcef1	admins	467064ce-15eb-414b-9803-040102c6cfaf	2022-04-13 20:01:46+03
\.


--
-- Data for Name: groups_permissions; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.groups_permissions (id, group_id, permission_id, created_at) FROM stdin;
f00738ea-6f6e-4ca8-ad0b-d886602fe1ab	d192081a-f71a-47b8-870a-0e397750e333	82a64dac-050b-4da2-984a-df9166437d6f	2022-04-09 11:48:48+03
355ad814-a7c4-4f30-8151-f15b169f2276	d192081a-f71a-47b8-870a-0e397750e333	d53e899c-32de-4816-b1b2-bcd4ccb0b378	2022-04-09 11:48:48+03
257b5c84-8b19-4a1b-82d2-ca69a07bb7ed	d192081a-f71a-47b8-870a-0e397750e333	92b4c052-00eb-4541-a97c-5ba6cc7db8d5	2022-04-09 11:48:48+03
f97fb561-0b77-4182-a6b2-9b08f293743d	d192081a-f71a-47b8-870a-0e397750e333	b95ff0d2-564b-4e66-8678-47d1391389d8	2022-04-09 11:48:48+03
e4056ee9-3319-4ed2-8f47-85efb0261233	cc507ba7-c409-44a2-b718-6a4a4de708f4	82a64dac-050b-4da2-984a-df9166437d6f	2022-04-09 12:01:25+03
8f2daead-d01e-4b7f-a4aa-d5c5564c600e	cc507ba7-c409-44a2-b718-6a4a4de708f4	92b4c052-00eb-4541-a97c-5ba6cc7db8d5	2022-04-09 12:01:25+03
9ab6ac8b-a016-4306-960e-f6fd5e8ad535	cc507ba7-c409-44a2-b718-6a4a4de708f4	b95ff0d2-564b-4e66-8678-47d1391389d8	2022-04-09 12:01:25+03
7f545e28-3189-431b-b173-0fca93f3eee5	cc507ba7-c409-44a2-b718-6a4a4de708f4	d53e899c-32de-4816-b1b2-bcd4ccb0b378	2022-04-09 12:01:25+03
6cc2596e-ad08-48f3-b00c-ac5e90fde7ca	557d7562-f607-4216-bc54-02e9b7efcef1	82a64dac-050b-4da2-984a-df9166437d6f	2022-04-13 20:01:46+03
8bbab499-4b73-40a5-acaf-5497fa722731	557d7562-f607-4216-bc54-02e9b7efcef1	92b4c052-00eb-4541-a97c-5ba6cc7db8d5	2022-04-13 20:01:46+03
b5679d8a-fb6f-4b86-8c7a-c6536aeebb71	557d7562-f607-4216-bc54-02e9b7efcef1	b95ff0d2-564b-4e66-8678-47d1391389d8	2022-04-13 20:01:46+03
af69ff82-3677-4e36-9185-8009b35b24ad	557d7562-f607-4216-bc54-02e9b7efcef1	d53e899c-32de-4816-b1b2-bcd4ccb0b378	2022-04-13 20:01:46+03
\.


--
-- Data for Name: masters; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.masters (id, name, email, password_hash, password_salt, created_at, tenant_id) FROM stdin;
b0bb32f7-b832-4271-a4a1-62400d30d164	rwst	radhika.mitter@snapnurse.com	$2b$10$0EjNTsTjFlzl/QdyKGaFXuhje.gmbFCEyv14Tzd0XiM3ESTJ8CWSC	10	2022-02-09 19:35:33+02	a9217ae8-ee34-4737-af03-d2bbc1e3e0d2
25672c3a-d9c3-432e-b661-a900646bea7d	whatislove	zubko.2007@gmail.co	$2b$10$0EjNTsTjFlzl/QdyKGaFXuhje.gmbFCEyv14Tzd0XiM3ESTJ8CWSC	10	2022-02-09 19:16:51+02	c05c5659-1b3f-45e9-b884-07a2f189d708
7d3e6fdd-f79b-4476-99fc-99f3d60d37d7	whatislove	zubko.2007@gmail.com	$2b$10$0EjNTsTjFlzl/QdyKGaFXuhje.gmbFCEyv14Tzd0XiM3ESTJ8CWSC	10	2022-02-09 19:15:37+02	413bc75b-4ffc-4783-a3f9-5cc2f1b6dfa7
37b10980-9c5d-41b0-bfa2-4230a44e8418	radhika	radhika1.mitter@snapnurse.com	$2b$10$jeSyYU/ZAnlW/InPUtMe2uP/6N8g66T2TpfQYPxF5rw72J6r.FJKW	$2b$10$jeSyYU/ZAnlW/InPUtMe2u	2022-02-09 19:55:32+02	c5aefa6d-44a9-4583-a9e5-f6490ab8f632
88482f0c-3176-4e9b-80fc-aba7c7883d95	qwer	zubko.2001@gmail.com	$2b$10$POyFdEewnUvXk6ay9LLyY.sTHhjoruclPUR6mklHYAhP6g9mHiZJ.	$2b$10$POyFdEewnUvXk6ay9LLyY.	2022-02-12 10:35:31+02	80e20f36-07fc-48e6-8383-7a20afdded7c
566c7a65-2235-4c27-9296-d3f41228e414	MASTER	1649494327.363@test.test	$2b$10$gIhp8wgUF.8MXtdIr.Vexe1NCKAAiHoNz6atrEjBhEiUVlJXNFcSS	$2b$10$gIhp8wgUF.8MXtdIr.Vexe	2022-04-09 11:52:08+03	aaa791dd-f98f-49d4-84da-fa3886f7418b
a39789db-473b-4b93-abb3-eb752982607c	MASTER	master@test.test	$2b$10$SJsJibC7rmdpveFeSeG0qOlxKpx5VeZuXPczcM.Sd7Yly8JKWDMSO	$2b$10$SJsJibC7rmdpveFeSeG0qO	2022-04-09 11:59:00+03	5890341b-33ee-4405-b99c-9879152b7d46
3ca151c9-e75c-492a-aba8-a45dbebd92eb	MASTER	1649495044.073@test.test	$2b$10$qkZKyDMxjyw6OXEe.LMki.KuiuisOLiWf7CgIAfuJsuqyfqoCddmq	$2b$10$qkZKyDMxjyw6OXEe.LMki.	2022-04-09 12:04:05+03	1a0e403a-5a54-45e7-a884-0fcb19c1082c
4bbdc006-d1b1-40b1-9fc4-85f50ab130d5	radhika	radhika.mitter1@snapnurse.com	$2b$10$TY2bKwHNW4HEQL5wPMOg9u7Y7m9MvSIly1W3vV1omjB.LkTPISD2G	$2b$10$TY2bKwHNW4HEQL5wPMOg9u	2022-04-13 20:00:54+03	467064ce-15eb-414b-9803-040102c6cfaf
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.permissions (id, name, created_at) FROM stdin;
92b4c052-00eb-4541-a97c-5ba6cc7db8d5	manage-eam	2022-02-09 19:06:06+02
b95ff0d2-564b-4e66-8678-47d1391389d8	manage-sc	2022-02-09 19:06:06+02
d53e899c-32de-4816-b1b2-bcd4ccb0b378	manage-slc	2022-02-09 19:06:06+02
82a64dac-050b-4da2-984a-df9166437d6f	manage-bs	2022-02-09 19:06:06+02
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.tenants (id, name, created_at) FROM stdin;
413bc75b-4ffc-4783-a3f9-5cc2f1b6dfa7	f9e554eb-8aef-481d-b09e-e0683aeb316d	2022-02-09 19:15:37+02
c05c5659-1b3f-45e9-b884-07a2f189d708	5ce70028-144b-4fbd-a1d9-3be9f25fca19	2022-02-09 19:16:51+02
a9217ae8-ee34-4737-af03-d2bbc1e3e0d2	4ad42041-325c-414a-8165-0263d4afc4df	2022-02-09 19:35:33+02
80e20f36-07fc-48e6-8383-7a20afdded7c	spacex	2022-02-12 10:35:31+02
aaa791dd-f98f-49d4-84da-fa3886f7418b	dfa32322-d01c-4441-9ca3-b2c0f3727cc9	2022-04-09 11:52:08+03
5890341b-33ee-4405-b99c-9879152b7d46	MASTER	2022-04-09 11:59:00+03
1a0e403a-5a54-45e7-a884-0fcb19c1082c	013d9212-d36e-4dac-a929-ea3a22b4f46f	2022-04-09 12:04:05+03
467064ce-15eb-414b-9803-040102c6cfaf	d5395bb9-e1ab-441a-8c0f-07fecff439e4	2022-04-13 20:00:54+03
c5aefa6d-44a9-4583-a9e5-f6490ab8f632	spaceee	2022-02-09 19:55:32+02
\.


--
-- Data for Name: users_groups; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.users_groups (id, user_id, group_id, created_at) FROM stdin;
a011a52f-396a-4ef7-bb41-73da3a169010	860678b1-87f6-48b1-95f7-8597341fc8ae	d192081a-f71a-47b8-870a-0e397750e333	2022-04-09 11:48:48+03
c250de04-c08b-4d2a-b5ae-afe396e2be21	58ccc5b2-14e1-4a23-aec8-f3b3570d4de4	d192081a-f71a-47b8-870a-0e397750e333	2022-04-09 11:48:48+03
57c9ebc8-e377-415f-b0fe-82427fbb45e2	ada20b36-1c17-476e-9c1d-d32d146c034f	d192081a-f71a-47b8-870a-0e397750e333	2022-04-09 11:48:48+03
dda2d2ce-0ba0-43b7-9316-10052ecf5f5f	dc2cd1b0-85ec-4659-a848-ebcfc6399319	d192081a-f71a-47b8-870a-0e397750e333	2022-04-09 11:49:05+03
06233403-2273-4aa6-b63c-fc764874397e	dd39fee2-e7bf-4790-a026-e2cfcc7437ac	cc507ba7-c409-44a2-b718-6a4a4de708f4	2022-04-09 12:01:34+03
16769641-dc8c-4047-bb3e-e86255523195	33551c3a-9054-46a5-a5ae-084fb9e7d618	557d7562-f607-4216-bc54-02e9b7efcef1	2022-04-13 20:01:57+03
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: entity_access_management; Owner: postgres
--

COPY entity_access_management.workers (id, name, password_hash, password_salt, tenant_id, created_at) FROM stdin;
1b2a6994-97e1-4a60-ab02-b2139bfed124	sdadsa	$2b$10$OUlsml7jPpseycMoKH/qa.QZkgrixbGjwyUF9W/XU1EzXtMHd41aG	$2b$10$OUlsml7jPpseycMoKH/qa.	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-02-15 11:39:12+02
8e2bea91-b258-4f30-b114-762303d93b87	aasdas	$2b$10$kvLoi9jLHIyRSumgXPF3K.SkV0BR3S7NpPM0iW8YfHBxnxefF1N/m	$2b$10$kvLoi9jLHIyRSumgXPF3K.	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-02-15 11:47:35+02
91cc0950-7777-4195-a05e-ef5dc6321bbf	sdsfs	$2b$10$IeJGSRt6ZrrBAc.dwhPRT.yQMX.ktX2XwDaTAqbHZ880ZM.qq7Aoq	$2b$10$IeJGSRt6ZrrBAc.dwhPRT.	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-02-15 11:51:51+02
860678b1-87f6-48b1-95f7-8597341fc8ae	page	$2b$10$EcftRSpdAC731scbYVkve.g9bjnjWBQ9o0UjVAaU4vfxoeK6vNo9S	$2b$10$EcftRSpdAC731scbYVkve.	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-03-01 12:17:51+02
58ccc5b2-14e1-4a23-aec8-f3b3570d4de4	pacanchek	$2b$10$2FpXex8TzkMJGkRCXleVgehW/meTpMSjShzgUyaG..s/88gbRm/v.	$2b$10$2FpXex8TzkMJGkRCXleVge	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-03-02 15:05:54+02
ada20b36-1c17-476e-9c1d-d32d146c034f	111	$2b$10$HGJMhLWwUOq0ftfWL1tfdOI7ASgPONGXQWFCrnaYdRHccffJTtaHG	$2b$10$HGJMhLWwUOq0ftfWL1tfdO	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-03-02 15:50:43+02
dc2cd1b0-85ec-4659-a848-ebcfc6399319	myfawadmin	$2b$10$dLegdoQQ.J0JNaIn7j7kreIj..pJ66F3a/SaDs038QOzo57WjrdH2	$2b$10$dLegdoQQ.J0JNaIn7j7kre	80e20f36-07fc-48e6-8383-7a20afdded7c	2022-04-09 11:49:05+03
dd39fee2-e7bf-4790-a026-e2cfcc7437ac	Bob	$2b$10$0KCkAS093VvZrDktQ5vvhOqRBum75qh4jar.xLr0oLkpsjHLFvmim	$2b$10$0KCkAS093VvZrDktQ5vvhO	5890341b-33ee-4405-b99c-9879152b7d46	2022-04-09 12:01:34+03
33551c3a-9054-46a5-a5ae-084fb9e7d618	danil	$2b$10$SH5KG8SXYgZVlYacgOui9eAeqOajOPilIAQ0e/WILIMk9CrJRW56y	$2b$10$SH5KG8SXYgZVlYacgOui9e	467064ce-15eb-414b-9803-040102c6cfaf	2022-04-13 20:01:57+03
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, name, batch, migration_time) FROM stdin;
1	20220116123530_add_masters_table.ts	1	2022-02-09 19:06:06.653+02
2	20220205143853_add_permissions_table.ts	1	2022-02-09 19:06:06.659+02
3	20220205152216_add_tenants_table.ts	1	2022-02-09 19:06:06.663+02
4	20220205154833_add_workers_table.ts	1	2022-02-09 19:06:06.676+02
5	20220205170455_add_groups_table.ts	1	2022-02-09 19:06:06.681+02
6	20220206145038_add_users_groups_table.ts	1	2022-02-09 19:06:06.687+02
7	20220206154909_add_groups_permissions_table.ts	1	2022-02-09 19:06:06.697+02
8	20220206164137_edit_masters_table.ts	1	2022-02-09 19:06:06.7+02
9	20220207071214_edit_permissions_table.ts	1	2022-02-09 19:06:06.702+02
10	20220207134835_edit_masters_tenant_id.ts	1	2022-02-09 19:06:06.704+02
11	20220208161915_edit_tenants_create_at.ts	1	2022-02-09 19:06:06.706+02
12	20220209151805_edit_tables_without_create_at_column.ts	1	2022-02-09 19:06:06.709+02
13	20220216121833_add_binary_storage_spaces_table.ts	2	2022-03-01 12:08:41.887+02
14	20220216131912_add_binary_storage_objects_table.ts	2	2022-03-01 12:08:41.902+02
15	20220216181521_add_operation_systems_table.ts	2	2022-03-01 12:08:41.946+02
16	20220217065330_add_serverless_computing_functions_table.ts	2	2022-03-01 12:08:41.953+02
17	20220218075523_add_key_pairs_table.ts	2	2022-03-01 12:08:41.958+02
18	20220218080541_add_instances_table.ts	2	2022-03-01 12:08:41.967+02
19	20220219134401_update_functions_table.ts	2	2022-03-01 12:08:41.968+02
20	20220219201116_edit_instances_table.ts	2	2022-03-01 12:08:41.97+02
21	20220219202732_edit_instances_table.ts	2	2022-03-01 12:08:41.973+02
22	20220222084102_edit_worker_tenant_id.ts	2	2022-03-01 12:08:41.975+02
\.


--
-- Data for Name: migrations_lock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations_lock (index, is_locked) FROM stdin;
1	0
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: server_computing; Owner: postgres
--

COPY server_computing.instances (id, name, created_at, key_pair_id, username, hostname, operation_system_id, created_by, aws_instance_id, tenant_id) FROM stdin;
\.


--
-- Data for Name: key_pairs; Type: TABLE DATA; Schema: server_computing; Owner: postgres
--

COPY server_computing.key_pairs (id, ssh_pem_file_content, created_at) FROM stdin;
\.


--
-- Data for Name: operation_systems; Type: TABLE DATA; Schema: server_computing; Owner: postgres
--

COPY server_computing.operation_systems (id, name, created_at, aws_generation_name) FROM stdin;
9e5b09e5-0499-4032-86e5-816eca7a2f96	ubuntu-server-18	2022-03-01 12:08:41+02	ami-042ad9eec03638628
1478cd64-35f2-4838-beb5-ad5c800efb3a	ubuntu-server-20	2022-03-01 12:08:41+02	ami-0d527b8c289b4af7f
9bf5f3c4-ada6-447b-8d0a-7f12b301e899	debian	2022-03-01 12:08:41+02	ami-0245697ee3e07e755
1defd6c5-92a4-4f9d-b690-e4a7841f3be2	windows-server-2019	2022-03-01 12:08:41+02	ami-09d416ef29471299a
\.


--
-- Data for Name: functions; Type: TABLE DATA; Schema: serverless_computing; Owner: postgres
--

COPY serverless_computing.functions (id, name, created_at, source_code, created_by, aws_lambda_id, updated_at) FROM stdin;
c222949a-b078-4609-971b-d97bd3ea3621	myfn	2022-04-09 11:50:31+03	exports.handler = async (event) => {\n    const response = {\n        statusCode: 200,\n        body: JSON.stringify('Hello Radhika!'),\n    };\n    return response;\n};\n	dc2cd1b0-85ec-4659-a848-ebcfc6399319	arn:aws:lambda:eu-central-1:560269426264:function:myfn	2022-04-09 11:50:59.58+03
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 22, true);


--
-- Name: migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_lock_index_seq', 1, true);


--
-- Name: objects binary_storage_objects_id_unique; Type: CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.objects
    ADD CONSTRAINT binary_storage_objects_id_unique UNIQUE (id);


--
-- Name: spaces binary_storage_spaces_id_unique; Type: CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.spaces
    ADD CONSTRAINT binary_storage_spaces_id_unique UNIQUE (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: spaces space_pkey; Type: CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.spaces
    ADD CONSTRAINT space_pkey PRIMARY KEY (id);


--
-- Name: groups entity_access_management_groups_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups
    ADD CONSTRAINT entity_access_management_groups_id_unique UNIQUE (id);


--
-- Name: groups_permissions entity_access_management_groups_permissions_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups_permissions
    ADD CONSTRAINT entity_access_management_groups_permissions_id_unique UNIQUE (id);


--
-- Name: masters entity_access_management_masters_email_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.masters
    ADD CONSTRAINT entity_access_management_masters_email_unique UNIQUE (email);


--
-- Name: masters entity_access_management_masters_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.masters
    ADD CONSTRAINT entity_access_management_masters_id_unique UNIQUE (id);


--
-- Name: permissions entity_access_management_permissions_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.permissions
    ADD CONSTRAINT entity_access_management_permissions_id_unique UNIQUE (id);


--
-- Name: tenants entity_access_management_tenants_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.tenants
    ADD CONSTRAINT entity_access_management_tenants_id_unique UNIQUE (id);


--
-- Name: users_groups entity_access_management_users_groups_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.users_groups
    ADD CONSTRAINT entity_access_management_users_groups_id_unique UNIQUE (id);


--
-- Name: workers entity_access_management_workers_id_unique; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.workers
    ADD CONSTRAINT entity_access_management_workers_id_unique UNIQUE (id);


--
-- Name: groups_permissions groups_permissions_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups_permissions
    ADD CONSTRAINT groups_permissions_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: masters masters_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.masters
    ADD CONSTRAINT masters_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: users_groups users_groups_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.users_groups
    ADD CONSTRAINT users_groups_pkey PRIMARY KEY (id);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: migrations_lock migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations_lock
    ADD CONSTRAINT migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: key_pairs key_pairs_pkey; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.key_pairs
    ADD CONSTRAINT key_pairs_pkey PRIMARY KEY (id);


--
-- Name: operation_systems operation_systems_pkey; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.operation_systems
    ADD CONSTRAINT operation_systems_pkey PRIMARY KEY (id);


--
-- Name: instances server_computing_instances_id_unique; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT server_computing_instances_id_unique UNIQUE (id);


--
-- Name: key_pairs server_computing_key_pairs_id_unique; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.key_pairs
    ADD CONSTRAINT server_computing_key_pairs_id_unique UNIQUE (id);


--
-- Name: operation_systems server_computing_operation_systems_id_unique; Type: CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.operation_systems
    ADD CONSTRAINT server_computing_operation_systems_id_unique UNIQUE (id);


--
-- Name: functions functions_pkey; Type: CONSTRAINT; Schema: serverless_computing; Owner: postgres
--

ALTER TABLE ONLY serverless_computing.functions
    ADD CONSTRAINT functions_pkey PRIMARY KEY (id);


--
-- Name: functions serverless_computing_functions_id_unique; Type: CONSTRAINT; Schema: serverless_computing; Owner: postgres
--

ALTER TABLE ONLY serverless_computing.functions
    ADD CONSTRAINT serverless_computing_functions_id_unique UNIQUE (id);


--
-- Name: objects binary_storage_objects_space_id_foreign; Type: FK CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.objects
    ADD CONSTRAINT binary_storage_objects_space_id_foreign FOREIGN KEY (space_id) REFERENCES binary_storage.spaces(id);


--
-- Name: objects binary_storage_objects_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.objects
    ADD CONSTRAINT binary_storage_objects_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES entity_access_management.workers(id);


--
-- Name: spaces binary_storage_spaces_created_by_foreign; Type: FK CONSTRAINT; Schema: binary_storage; Owner: postgres
--

ALTER TABLE ONLY binary_storage.spaces
    ADD CONSTRAINT binary_storage_spaces_created_by_foreign FOREIGN KEY (created_by) REFERENCES entity_access_management.workers(id);


--
-- Name: groups_permissions entity_access_management_groups_permissions_group_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups_permissions
    ADD CONSTRAINT entity_access_management_groups_permissions_group_id_foreign FOREIGN KEY (group_id) REFERENCES entity_access_management.groups(id);


--
-- Name: groups_permissions entity_access_management_groups_permissions_permission_id_forei; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups_permissions
    ADD CONSTRAINT entity_access_management_groups_permissions_permission_id_forei FOREIGN KEY (permission_id) REFERENCES entity_access_management.permissions(id);


--
-- Name: groups entity_access_management_groups_tenant_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.groups
    ADD CONSTRAINT entity_access_management_groups_tenant_id_foreign FOREIGN KEY (tenant_id) REFERENCES entity_access_management.tenants(id);


--
-- Name: masters entity_access_management_masters_tenant_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.masters
    ADD CONSTRAINT entity_access_management_masters_tenant_id_foreign FOREIGN KEY (tenant_id) REFERENCES entity_access_management.tenants(id);


--
-- Name: users_groups entity_access_management_users_groups_group_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.users_groups
    ADD CONSTRAINT entity_access_management_users_groups_group_id_foreign FOREIGN KEY (group_id) REFERENCES entity_access_management.groups(id);


--
-- Name: users_groups entity_access_management_users_groups_user_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.users_groups
    ADD CONSTRAINT entity_access_management_users_groups_user_id_foreign FOREIGN KEY (user_id) REFERENCES entity_access_management.workers(id);


--
-- Name: workers entity_access_management_workers_tenant_id_foreign; Type: FK CONSTRAINT; Schema: entity_access_management; Owner: postgres
--

ALTER TABLE ONLY entity_access_management.workers
    ADD CONSTRAINT entity_access_management_workers_tenant_id_foreign FOREIGN KEY (tenant_id) REFERENCES entity_access_management.tenants(id);


--
-- Name: instances server_computing_instances_created_by_foreign; Type: FK CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT server_computing_instances_created_by_foreign FOREIGN KEY (created_by) REFERENCES entity_access_management.workers(id);


--
-- Name: instances server_computing_instances_key_pairs_id_foreign; Type: FK CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT server_computing_instances_key_pairs_id_foreign FOREIGN KEY (key_pair_id) REFERENCES server_computing.key_pairs(id);


--
-- Name: instances server_computing_instances_operation_system_id_foreign; Type: FK CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT server_computing_instances_operation_system_id_foreign FOREIGN KEY (operation_system_id) REFERENCES server_computing.operation_systems(id);


--
-- Name: instances server_computing_instances_tenant_id_foreign; Type: FK CONSTRAINT; Schema: server_computing; Owner: postgres
--

ALTER TABLE ONLY server_computing.instances
    ADD CONSTRAINT server_computing_instances_tenant_id_foreign FOREIGN KEY (tenant_id) REFERENCES entity_access_management.tenants(id);


--
-- Name: functions serverless_computing_functions_created_by_foreign; Type: FK CONSTRAINT; Schema: serverless_computing; Owner: postgres
--

ALTER TABLE ONLY serverless_computing.functions
    ADD CONSTRAINT serverless_computing_functions_created_by_foreign FOREIGN KEY (created_by) REFERENCES entity_access_management.workers(id);


--
-- PostgreSQL database dump complete
--

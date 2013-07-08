--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: administrativo; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE administrativo (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL
);


ALTER TABLE public.administrativo OWNER TO alumno;

--
-- Name: alumno; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE alumno (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    fecha_ingreso date NOT NULL,
    fecha_egreso date,
    motivo_egreso text,
    CONSTRAINT alumno_motivo_egreso_check CHECK (((motivo_egreso IS NULL) OR (motivo_egreso = ANY (ARRAY['ABANDONO'::text, 'EGRESO'::text, 'EXPULSION'::text]))))
);


ALTER TABLE public.alumno OWNER TO alumno;

--
-- Name: alumno_curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE alumno_curso (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL
);


ALTER TABLE public.alumno_curso OWNER TO alumno;

--
-- Name: asistencia; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE asistencia (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL,
    materia integer NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.asistencia OWNER TO alumno;

--
-- Name: curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE curso (
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL
);


ALTER TABLE public.curso OWNER TO alumno;

--
-- Name: docente; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE docente (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    carga_horaria integer NOT NULL,
    decreto text
);


ALTER TABLE public.docente OWNER TO alumno;

--
-- Name: docente_curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE docente_curso (
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL,
    tipo_documento text,
    numero_documento integer,
    materia integer NOT NULL
);


ALTER TABLE public.docente_curso OWNER TO alumno;

--
-- Name: seq_examen_id; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_examen_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_examen_id OWNER TO alumno;

--
-- Name: seq_examen_id; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_examen_id', 116, true);


--
-- Name: examen; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE examen (
    materia integer NOT NULL,
    fecha date NOT NULL,
    tipo text NOT NULL,
    folio text,
    ciclo_lectivo integer NOT NULL,
    tipo_doc_adm text NOT NULL,
    numero_doc_adm integer NOT NULL,
    curso_anio integer,
    curso_division text,
    curso_ciclo_lectivo integer,
    id integer DEFAULT nextval('seq_examen_id'::regclass) NOT NULL,
    CONSTRAINT examen_tipo_check CHECK ((tipo = ANY (ARRAY['P1'::text, 'P2'::text, 'EF'::text, 'PROM'::text])))
);


ALTER TABLE public.examen OWNER TO alumno;

--
-- Name: examen_alumno; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE examen_alumno (
    tipo_doc_alumno text NOT NULL,
    numero_doc_alumno integer NOT NULL,
    nota integer,
    examen integer NOT NULL
);


ALTER TABLE public.examen_alumno OWNER TO alumno;

--
-- Name: seq_localidad_codigo; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_localidad_codigo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_localidad_codigo OWNER TO alumno;

--
-- Name: seq_localidad_codigo; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_localidad_codigo', 59, true);


--
-- Name: localidad; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE localidad (
    codigo integer DEFAULT nextval('seq_localidad_codigo'::regclass) NOT NULL,
    nombre text NOT NULL,
    provincia text,
    codigo_postal integer
);


ALTER TABLE public.localidad OWNER TO alumno;

--
-- Name: seq_materia_codigo; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_materia_codigo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_materia_codigo OWNER TO alumno;

--
-- Name: seq_materia_codigo; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_materia_codigo', 47, true);


--
-- Name: materia; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE materia (
    codigo integer DEFAULT nextval('seq_materia_codigo'::regclass) NOT NULL,
    nombre text NOT NULL,
    duracion text NOT NULL,
    anio integer NOT NULL,
    cuatrimestre integer,
    CONSTRAINT chk_duracion CHECK ((duracion = ANY (ARRAY['A'::text, 'C'::text]))),
    CONSTRAINT materia_anio_check CHECK ((anio = ANY (ARRAY[1, 2, 3])))
);


ALTER TABLE public.materia OWNER TO alumno;

--
-- Name: persona; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE persona (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    apellido text NOT NULL,
    nombre text NOT NULL,
    domicilio_localidad integer NOT NULL,
    email text,
    fecha_nacimiento date,
    cuit text NOT NULL,
    telefono text,
    domicilio_calle text,
    domicilio_altura integer,
    localidad_nacimiento integer,
    CONSTRAINT persona_cuit_check CHECK ((cuit ~ '\d{2}-\d{8}-\d'::text)),
    CONSTRAINT persona_email_check CHECK (((email IS NULL) OR (email ~ '^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$'::text))),
    CONSTRAINT persona_fecha_nac_check CHECK ((fecha_nacimiento < (now() - '18 years'::interval))),
    CONSTRAINT persona_numero_documento_check CHECK (((numero_documento >= 1000000) AND (numero_documento <= 99999999))),
    CONSTRAINT persona_tipo_documento_check CHECK ((tipo_documento = ANY (ARRAY['LE'::text, 'LC'::text, 'DNI'::text])))
);


ALTER TABLE public.persona OWNER TO alumno;

--
-- Data for Name: administrativo; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO administrativo VALUES ('DNI', 24757407);
INSERT INTO administrativo VALUES ('DNI', 24757409);


--
-- Data for Name: alumno; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO alumno VALUES ('DNI', 33280222, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33315592, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33316018, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33316071, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33323237, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33345183, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33345365, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33355138, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392509, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36320922, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36320931, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36321774, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36321864, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36322082, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36322225, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36334179, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36393277, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36393283, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36494625, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36580201, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 16460835, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29836430, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29957251, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29984297, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30008678, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30063150, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30505921, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30517538, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30519907, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550115, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550175, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550240, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550811, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550812, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30578189, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30580269, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30801436, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30806005, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30811435, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30853757, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30859030, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30883617, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30883736, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30936707, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30936882, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30965345, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30976180, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30976361, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31117929, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31123263, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31148538, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31148849, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31211783, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31243077, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31350868, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31394171, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31475483, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31504713, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31587087, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31625696, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31637802, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31697934, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31711881, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31799287, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31914692, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31963639, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31985359, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31985648, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32084930, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32142694, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32169295, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32189328, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32189485, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32220094, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32233569, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32388506, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32429147, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32538462, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32568674, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32650030, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32697667, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32720290, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32722000, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32748768, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32777463, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32873808, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32893019, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32923291, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954311, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954340, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954901, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33039280, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33059038, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33185278, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392529, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392717, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33529182, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33574918, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33616875, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33616890, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33652568, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771513, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771791, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771876, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33772202, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33775224, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33793261, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33946796, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33952437, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34087350, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34144920, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34486653, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34486688, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488622, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488624, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488766, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488894, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34621905, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34663788, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34664242, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34667682, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34726897, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34784310, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34868669, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34967321, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35002167, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35030083, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35047205, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35047249, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35171950, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35172890, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35176552, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35218837, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35381326, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35381482, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35382451, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35383105, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35659009, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35659086, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35886876, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35888484, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889336, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889531, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889600, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889868, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35928690, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36106160, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36181720, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36212878, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36647874, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36718873, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36719465, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36791907, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37006500, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37067840, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37068029, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37068721, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37069026, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147923, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147949, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147984, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37148086, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149129, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149146, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149531, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149573, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149762, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37151708, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37154408, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347319, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347611, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347866, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37550801, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37641321, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37665309, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37665374, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37666304, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676641, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676667, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676847, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676898, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37764671, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37764772, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37860610, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37860666, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37909364, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37988265, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046207, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046260, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046492, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38080933, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38147591, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38232383, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38300437, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38443349, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38535811, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38535815, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38711051, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784419, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784484, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784653, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38799829, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38801908, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38803935, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38806179, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 39059353, '2010-01-01', NULL, NULL);


--
-- Data for Name: alumno_curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO alumno_curso VALUES ('DNI', 35218837, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32388506, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34667682, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30801436, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149129, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33772202, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30883736, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35888484, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35382451, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30883617, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35176552, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33574918, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32893019, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32748768, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38046260, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32169295, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37069026, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32189328, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31123263, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35171950, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31148849, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35928690, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32220094, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33775224, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38799829, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34486653, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31243077, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31799287, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32720290, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33323237, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32873808, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35047205, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36321774, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37764772, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36494625, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34664242, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32923291, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37147984, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30505921, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488624, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149146, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31914692, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347319, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37860666, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31985648, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35381326, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149762, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37154408, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550811, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30811435, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32777463, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38147591, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37148086, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38535815, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34621905, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35030083, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33185278, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30859030, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31148538, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347866, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36321864, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37676667, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34087350, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34726897, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37860610, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35383105, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 39059353, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 29984297, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550240, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36322082, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36212878, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37006500, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37676898, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35002167, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36719465, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38046492, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30580269, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30936882, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 16460835, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33771876, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36580201, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35047249, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31350868, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34486688, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38443349, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33793261, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550115, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488622, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149531, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31625696, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35889600, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35381482, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38784484, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31963639, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31985359, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30806005, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149573, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37641321, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550812, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 29836430, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37068029, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33316071, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30519907, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30936707, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32538462, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36334179, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33316018, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30008678, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36181720, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33616890, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34967321, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347611, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488894, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31504713, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33059038, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38803935, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37666304, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31211783, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38806179, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36393277, 3, '1', 2012);


--
-- Data for Name: asistencia; Type: TABLE DATA; Schema: public; Owner: alumno
--



--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO curso VALUES (1, '1', 2012);
INSERT INTO curso VALUES (1, '2', 2012);
INSERT INTO curso VALUES (2, '1', 2012);
INSERT INTO curso VALUES (3, '1', 2012);


--
-- Data for Name: docente; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO docente VALUES ('DNI', 23099369, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23172838, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23172855, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23547074, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23569160, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23712808, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23774554, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887357, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887499, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887854, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24212891, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24637839, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650524, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650575, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650693, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650865, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650982, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757164, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757243, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757264, 0, NULL);


--
-- Data for Name: docente_curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24757264, 1);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24637839, 2);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24757243, 3);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23712808, 4);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887854, 5);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172838, 6);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24212891, 7);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24650575, 8);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172838, 9);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23712808, 10);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887499, 11);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172855, 12);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24637839, 13);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23569160, 14);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887357, 15);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172855, 16);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650693, 2);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23569160, 4);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 5);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650524, 6);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650524, 7);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650693, 9);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 10);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24637839, 11);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 12);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24637839, 13);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650982, 14);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23774554, 15);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23887499, 16);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23887357, 17);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 18);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650524, 19);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650865, 20);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 21);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23172838, 22);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23774554, 23);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 24);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23712808, 25);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650693, 26);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23712808, 27);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 28);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 29);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24212891, 30);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 31);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650865, 32);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 33);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 34);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24757243, 35);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887499, 36);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887357, 37);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887854, 38);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887357, 39);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650575, 41);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650982, 42);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23547074, 43);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23547074, 44);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650524, 45);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887499, 46);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24212891, 47);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24757164, 1);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24212891, 3);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23172838, 8);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24637839, 40);


--
-- Data for Name: examen; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO examen VALUES (1, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 1);
INSERT INTO examen VALUES (1, '2012-11-06', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 2);
INSERT INTO examen VALUES (2, '2012-06-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 3);
INSERT INTO examen VALUES (2, '2012-10-21', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 4);
INSERT INTO examen VALUES (3, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 5);
INSERT INTO examen VALUES (3, '2012-11-09', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 6);
INSERT INTO examen VALUES (4, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 7);
INSERT INTO examen VALUES (4, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 8);
INSERT INTO examen VALUES (5, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 9);
INSERT INTO examen VALUES (5, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 10);
INSERT INTO examen VALUES (7, '2012-05-27', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 11);
INSERT INTO examen VALUES (7, '2012-11-16', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 12);
INSERT INTO examen VALUES (8, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 13);
INSERT INTO examen VALUES (8, '2012-10-18', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 14);
INSERT INTO examen VALUES (12, '2012-05-14', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 15);
INSERT INTO examen VALUES (12, '2012-11-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 16);
INSERT INTO examen VALUES (13, '2012-06-11', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 17);
INSERT INTO examen VALUES (13, '2012-11-18', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 18);
INSERT INTO examen VALUES (14, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 19);
INSERT INTO examen VALUES (14, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 20);
INSERT INTO examen VALUES (15, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 21);
INSERT INTO examen VALUES (15, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 22);
INSERT INTO examen VALUES (17, '2012-05-30', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 23);
INSERT INTO examen VALUES (17, '2012-10-25', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 24);
INSERT INTO examen VALUES (18, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 25);
INSERT INTO examen VALUES (18, '2012-10-20', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 26);
INSERT INTO examen VALUES (20, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 27);
INSERT INTO examen VALUES (20, '2012-11-04', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 28);
INSERT INTO examen VALUES (21, '2012-05-19', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 29);
INSERT INTO examen VALUES (21, '2012-11-08', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 30);
INSERT INTO examen VALUES (22, '2012-06-08', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 31);
INSERT INTO examen VALUES (22, '2012-10-25', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 32);
INSERT INTO examen VALUES (23, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 33);
INSERT INTO examen VALUES (23, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 34);
INSERT INTO examen VALUES (24, '2012-05-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 35);
INSERT INTO examen VALUES (24, '2012-11-17', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 36);
INSERT INTO examen VALUES (25, '2012-05-24', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 37);
INSERT INTO examen VALUES (25, '2012-10-24', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 38);
INSERT INTO examen VALUES (26, '2012-06-07', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 39);
INSERT INTO examen VALUES (26, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 40);
INSERT INTO examen VALUES (27, '2012-06-14', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 41);
INSERT INTO examen VALUES (27, '2012-11-04', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 42);
INSERT INTO examen VALUES (28, '2012-05-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 43);
INSERT INTO examen VALUES (28, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 44);
INSERT INTO examen VALUES (29, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 45);
INSERT INTO examen VALUES (29, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 46);
INSERT INTO examen VALUES (30, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 47);
INSERT INTO examen VALUES (30, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 48);
INSERT INTO examen VALUES (31, '2012-05-13', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 49);
INSERT INTO examen VALUES (31, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 50);
INSERT INTO examen VALUES (32, '2012-05-13', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 51);
INSERT INTO examen VALUES (32, '2012-11-02', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 52);
INSERT INTO examen VALUES (34, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 53);
INSERT INTO examen VALUES (34, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 54);
INSERT INTO examen VALUES (37, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 55);
INSERT INTO examen VALUES (37, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 56);
INSERT INTO examen VALUES (38, '2012-06-07', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 57);
INSERT INTO examen VALUES (38, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 58);
INSERT INTO examen VALUES (40, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 59);
INSERT INTO examen VALUES (40, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 60);
INSERT INTO examen VALUES (42, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 61);
INSERT INTO examen VALUES (42, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 62);
INSERT INTO examen VALUES (43, '2012-05-22', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 63);
INSERT INTO examen VALUES (43, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 64);
INSERT INTO examen VALUES (44, '2012-05-25', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 65);
INSERT INTO examen VALUES (44, '2012-11-03', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 66);
INSERT INTO examen VALUES (46, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 67);
INSERT INTO examen VALUES (47, '2012-05-14', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 68);
INSERT INTO examen VALUES (47, '2012-10-27', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 69);
INSERT INTO examen VALUES (6, '2012-04-12', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 70);
INSERT INTO examen VALUES (6, '2012-06-07', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 71);
INSERT INTO examen VALUES (9, '2012-04-03', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 72);
INSERT INTO examen VALUES (9, '2012-05-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 73);
INSERT INTO examen VALUES (10, '2012-04-05', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 74);
INSERT INTO examen VALUES (10, '2012-06-10', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 75);
INSERT INTO examen VALUES (19, '2012-04-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 76);
INSERT INTO examen VALUES (19, '2012-05-27', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 77);
INSERT INTO examen VALUES (35, '2012-04-06', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 78);
INSERT INTO examen VALUES (35, '2012-05-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 79);
INSERT INTO examen VALUES (36, '2012-04-02', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 80);
INSERT INTO examen VALUES (36, '2012-05-29', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 81);
INSERT INTO examen VALUES (1, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 82);
INSERT INTO examen VALUES (1, '2012-11-03', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 83);
INSERT INTO examen VALUES (2, '2012-05-22', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 84);
INSERT INTO examen VALUES (2, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 85);
INSERT INTO examen VALUES (3, '2012-05-20', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 86);
INSERT INTO examen VALUES (3, '2012-10-24', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 87);
INSERT INTO examen VALUES (4, '2012-06-13', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 88);
INSERT INTO examen VALUES (4, '2012-11-16', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 89);
INSERT INTO examen VALUES (5, '2012-05-26', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 90);
INSERT INTO examen VALUES (5, '2012-11-17', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 91);
INSERT INTO examen VALUES (7, '2012-06-08', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 92);
INSERT INTO examen VALUES (7, '2012-11-20', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 93);
INSERT INTO examen VALUES (8, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 94);
INSERT INTO examen VALUES (8, '2012-11-05', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 95);
INSERT INTO examen VALUES (12, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 96);
INSERT INTO examen VALUES (12, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 97);
INSERT INTO examen VALUES (13, '2012-06-09', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 98);
INSERT INTO examen VALUES (13, '2012-10-20', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 99);
INSERT INTO examen VALUES (14, '2012-06-14', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 100);
INSERT INTO examen VALUES (14, '2012-10-17', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 101);
INSERT INTO examen VALUES (15, '2012-05-12', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 102);
INSERT INTO examen VALUES (15, '2012-11-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 103);
INSERT INTO examen VALUES (45, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 104);
INSERT INTO examen VALUES (45, '2012-11-09', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 105);
INSERT INTO examen VALUES (46, '2012-06-05', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 106);
INSERT INTO examen VALUES (11, '2012-08-28', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 107);
INSERT INTO examen VALUES (11, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 108);
INSERT INTO examen VALUES (16, '2012-09-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 109);
INSERT INTO examen VALUES (16, '2012-10-28', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 110);
INSERT INTO examen VALUES (33, '2012-08-30', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 111);
INSERT INTO examen VALUES (33, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 112);
INSERT INTO examen VALUES (39, '2012-09-02', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 113);
INSERT INTO examen VALUES (39, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 114);
INSERT INTO examen VALUES (41, '2012-09-09', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 115);
INSERT INTO examen VALUES (41, '2012-11-08', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 116);


--
-- Data for Name: examen_alumno; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 4);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 10, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 5, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 75);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 74);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 73);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 71);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 70);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 22);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 11);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 8);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 7);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 2, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 2, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 71);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 12);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 2, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 4, 70);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 95);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 94);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 6, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 2, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 2, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 96);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 93);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 92);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 89);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 97);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 83);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 2, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 82);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 82);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 2, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 5, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 2, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 97);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 88);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 86);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 85);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 2, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 2, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 112);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 2, 111);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 52);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 45);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 38);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 35);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 2, 34);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 112);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 54);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 37);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 30);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 2, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 51);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 47);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 33);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 29);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 2, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 2, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 35);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 2, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 112);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 76);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 43);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 32);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 55);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 113);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 105);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 79);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 65);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 56);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 108);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 19);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 18);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 17);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 16);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 12);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 11);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 6, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 60);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 3, 58);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 115);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 113);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 104);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 81);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 66);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 62);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 58);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 57);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 116);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 114);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 104);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 81);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 79);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 64);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 61);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 57);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 56);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 55);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 8, 106);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 61);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 59);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 55);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 106);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 104);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 79);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 64);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 61);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 60);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 59);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 55);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 115);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 105);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 104);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 81);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 79);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 67);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 66);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 65);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 63);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 61);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 58);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 56);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 55);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 116);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 113);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 105);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 65);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 63);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 116);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 113);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 105);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 80);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 79);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 69);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 66);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 63);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 61);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 58);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 57);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 114);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 106);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 105);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 81);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 80);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 69);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 66);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 65);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 63);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 62);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 58);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 56);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 6, 55);


--
-- Data for Name: localidad; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO localidad VALUES (1, 'PASO DE INDIOS', NULL, NULL);
INSERT INTO localidad VALUES (2, 'CAMARONES', NULL, NULL);
INSERT INTO localidad VALUES (3, 'PASO DEL SAPO', NULL, NULL);
INSERT INTO localidad VALUES (4, 'ESQUEL', NULL, NULL);
INSERT INTO localidad VALUES (5, 'PUERTO MADRYN', NULL, NULL);
INSERT INTO localidad VALUES (6, 'COMODORO RIVADAVIA', NULL, NULL);
INSERT INTO localidad VALUES (7, 'TREVELIN', NULL, NULL);
INSERT INTO localidad VALUES (8, 'MARTINEZ', NULL, NULL);
INSERT INTO localidad VALUES (9, 'JOSE DE SAN MARTIN', NULL, NULL);
INSERT INTO localidad VALUES (10, 'GASTRE', NULL, NULL);
INSERT INTO localidad VALUES (11, 'LAGO PUELO', NULL, NULL);
INSERT INTO localidad VALUES (12, 'TECKA', NULL, NULL);
INSERT INTO localidad VALUES (13, 'GAN-GAN', NULL, NULL);
INSERT INTO localidad VALUES (14, 'CARRENLEUFU', NULL, NULL);
INSERT INTO localidad VALUES (15, 'EL MAITEN', NULL, NULL);
INSERT INTO localidad VALUES (16, 'RIO PICO', NULL, NULL);
INSERT INTO localidad VALUES (17, 'PUERTO PIRAMIDE', NULL, NULL);
INSERT INTO localidad VALUES (18, 'RADA TILLY', NULL, NULL);
INSERT INTO localidad VALUES (19, 'DR. RICARDO ROJAS', NULL, NULL);
INSERT INTO localidad VALUES (21, 'RAWSON', NULL, NULL);
INSERT INTO localidad VALUES (22, 'CUSHAMEN', NULL, NULL);
INSERT INTO localidad VALUES (23, 'LAS PLUMAS', NULL, NULL);
INSERT INTO localidad VALUES (24, 'DOLAVON', NULL, NULL);
INSERT INTO localidad VALUES (25, 'GUALJAINA', NULL, NULL);
INSERT INTO localidad VALUES (26, 'TRELEW', NULL, NULL);
INSERT INTO localidad VALUES (28, 'RIO MAYO', NULL, NULL);
INSERT INTO localidad VALUES (29, 'EPUYEN', NULL, NULL);
INSERT INTO localidad VALUES (30, 'SARMIENTO', NULL, NULL);
INSERT INTO localidad VALUES (31, 'CORCOVADO', NULL, NULL);
INSERT INTO localidad VALUES (32, 'FACUNDO', NULL, NULL);
INSERT INTO localidad VALUES (33, 'EL BOLSON', NULL, NULL);
INSERT INTO localidad VALUES (34, 'GAIMAN', NULL, NULL);
INSERT INTO localidad VALUES (35, 'PLAYA UNION', NULL, NULL);
INSERT INTO localidad VALUES (36, 'ALTO RIO SENGUER', NULL, NULL);
INSERT INTO localidad VALUES (37, 'EL HOYO', NULL, NULL);
INSERT INTO localidad VALUES (38, 'CORDOBA', NULL, NULL);
INSERT INTO localidad VALUES (39, 'LELEQUE', NULL, NULL);
INSERT INTO localidad VALUES (40, 'CHOLILA', NULL, NULL);
INSERT INTO localidad VALUES (41, 'GARAYALDE', NULL, NULL);
INSERT INTO localidad VALUES (42, 'CERRO CENTINELA', NULL, NULL);
INSERT INTO localidad VALUES (43, 'BUEN PASTO', NULL, NULL);
INSERT INTO localidad VALUES (44, 'GOBERNADOR COSTA', NULL, NULL);
INSERT INTO localidad VALUES (45, 'DEPARTAMENTO CUSHAMEN', NULL, NULL);
INSERT INTO localidad VALUES (46, 'LAS GOLONDRINAS', NULL, NULL);
INSERT INTO localidad VALUES (47, 'GENERAL MOSCONI (KM3)', NULL, NULL);
INSERT INTO localidad VALUES (48, 'SEPAUCAL', NULL, NULL);
INSERT INTO localidad VALUES (49, 'SAN LUIS', NULL, NULL);
INSERT INTO localidad VALUES (50, 'VILLA CARLOS PAZ', NULL, NULL);
INSERT INTO localidad VALUES (51, 'SAN RAFAEL', NULL, NULL);
INSERT INTO localidad VALUES (52, 'LA PLATA', NULL, NULL);
INSERT INTO localidad VALUES (53, 'COMANDANTE LUIS PIEDRABUENA', NULL, NULL);
INSERT INTO localidad VALUES (54, 'RAFAELA', NULL, NULL);
INSERT INTO localidad VALUES (57, 'WILDE', NULL, NULL);
INSERT INTO localidad VALUES (58, 'LANGUIÑEO', NULL, NULL);
INSERT INTO localidad VALUES (59, '25 DE MAYO', 'CHUBUT', 0);
INSERT INTO localidad VALUES (55, 'ADROGUE', 'CHUBUT', 0);
INSERT INTO localidad VALUES (56, 'BUENOS AIRES', '-', 0);
INSERT INTO localidad VALUES (27, 'CAPITAL FEDERAL', '-', 0);
INSERT INTO localidad VALUES (20, 'CIUDAD AUTONOMA DE BS. AS.', '-', 0);


--
-- Data for Name: materia; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO materia VALUES (1, 'FILOSOFIA Y ETICA', 'A', 1, NULL);
INSERT INTO materia VALUES (2, 'COMUNICACIÓN SOCIAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (3, 'PROBLEMÁTICA SOCIO-CULTURAL CONTEMPORANEA', 'A', 1, NULL);
INSERT INTO materia VALUES (4, 'PSICOLOGÍA', 'A', 1, NULL);
INSERT INTO materia VALUES (5, 'INGLES TECNICO', 'A', 1, NULL);
INSERT INTO materia VALUES (7, 'DEFENSA PERSONAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (8, 'ORGANIZACIÓN Y LEGISLACION POLICIAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (12, 'EDUCACION FISICA I', 'A', 1, NULL);
INSERT INTO materia VALUES (13, 'DERECHO CONSTITUCIONAL', 'A', 1, NULL);
INSERT INTO materia VALUES (14, 'DERECHO PENAL', 'A', 1, NULL);
INSERT INTO materia VALUES (15, 'DERECHO PROCESAL PENAL', 'A', 1, NULL);
INSERT INTO materia VALUES (17, 'RELACIONES HUMANAS', 'A', 2, NULL);
INSERT INTO materia VALUES (18, 'COMUNICACIÓN SOCIAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (20, 'PSICOLOGIA CRIMINAL', 'A', 2, NULL);
INSERT INTO materia VALUES (21, 'EDI (INVESTIGACION CRIMINAL)', 'A', 2, NULL);
INSERT INTO materia VALUES (22, 'DERECHO PENAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (23, 'DERECHO PROCESAL PENAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (24, 'METODOLOGIA DE INVESTIGACION I', 'A', 2, NULL);
INSERT INTO materia VALUES (25, 'EDUCACION FISICA II', 'A', 2, NULL);
INSERT INTO materia VALUES (26, 'MEDICINA LEGAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (27, 'ARMAS Y TIRO I', 'A', 2, NULL);
INSERT INTO materia VALUES (28, 'DEFENSA PERSONAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (29, 'SEGURIDAD PUBLICA I', 'A', 2, NULL);
INSERT INTO materia VALUES (30, 'ORGANIZACIÓN Y LEG. PCIAL. II', 'A', 2, NULL);
INSERT INTO materia VALUES (31, 'TECNICA DE PROCEDIMIENTOS POLICIALES', 'A', 2, NULL);
INSERT INTO materia VALUES (32, 'ACTUACION PREVENCIONAL I', 'A', 2, NULL);
INSERT INTO materia VALUES (34, 'CRIMINALISTICA', 'A', 2, NULL);
INSERT INTO materia VALUES (37, 'DERECHO ADMINISTRATIVO', 'A', 3, NULL);
INSERT INTO materia VALUES (38, 'METODOLOGIA DE LA INVESTIGACION II', 'A', 3, NULL);
INSERT INTO materia VALUES (40, 'PLANEAMIENTO ESTRATEGICO II', 'A', 3, NULL);
INSERT INTO materia VALUES (42, 'ARMAS Y TIRO II', 'A', 3, NULL);
INSERT INTO materia VALUES (43, 'PREVENCION COMUNITARIA DE LA VIOLENCIA', 'A', 3, NULL);
INSERT INTO materia VALUES (44, 'SEGURIDAD PUBLICA II', 'A', 3, NULL);
INSERT INTO materia VALUES (45, 'CRIMINOLOGIA', 'A', 3, NULL);
INSERT INTO materia VALUES (46, 'ACTUACION PREVENCIONAL II', 'A', 3, NULL);
INSERT INTO materia VALUES (47, 'EDI ( DERECHOS HUMANOS)', 'A', 3, NULL);
INSERT INTO materia VALUES (6, 'EDI (PROTOCOLO – CEREMONIAL)', 'C', 1, 1);
INSERT INTO materia VALUES (9, 'INTRODUCCION A LA SEGURIDAD PUBLICA', 'C', 1, 1);
INSERT INTO materia VALUES (10, 'MEDICINA LEGAL I', 'C', 1, 1);
INSERT INTO materia VALUES (19, 'PLANEAMIENTO ESTRATEGICO I', 'C', 2, 1);
INSERT INTO materia VALUES (35, 'SOCIEDAD', 'C', 3, 1);
INSERT INTO materia VALUES (36, 'ETICA PROFESIONAL', 'C', 3, 1);
INSERT INTO materia VALUES (11, 'BIOSEGURIDAD Y PRIMEROS AUXILIOS', 'C', 1, 2);
INSERT INTO materia VALUES (16, 'EDI (psicología evaluativa del arma)', 'C', 1, 2);
INSERT INTO materia VALUES (33, 'EDI', 'C', 2, 2);
INSERT INTO materia VALUES (39, 'PROTECCION CONTRA SINIESTROS', 'C', 3, 2);
INSERT INTO materia VALUES (41, 'EDI (DEFENSA PERSONAL POLICIAL Y USO DE TONFA)', 'C', 3, 2);


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO persona VALUES ('DNI', 31394171, 'PEREYRA', 'JULIETA FERNANDA', 6, NULL, '1985-09-04', '27-31394171-3', NULL, 'ESCALADA', 847, 55);
INSERT INTO persona VALUES ('DNI', 31475483, 'CIFUENTES', 'NELSON OSCAR', 30, NULL, '1985-08-10', '20-31475483-4', NULL, 'COMERCIO', 800, 32);
INSERT INTO persona VALUES ('DNI', 31504713, 'SAAVEDRA', 'KAREN JOHANA', 21, NULL, '1985-02-26', '27-31504713-5', NULL, 'ARISTOBULO', 1026, 58);
INSERT INTO persona VALUES ('DNI', 31587087, 'ALVAREZ', 'MAURO CRISTIAN', 18, NULL, '1986-03-02', '20-31587087-5', NULL, 'DIAGONAL', 949, 47);
INSERT INTO persona VALUES ('DNI', 31625696, 'LEDESMA', 'FACUNDO LUCIANO', 5, NULL, '1985-06-30', '20-31625696-6', NULL, 'ESCALADA', 288, 33);
INSERT INTO persona VALUES ('DNI', 31637802, 'ORTEGA', 'SEBASTIAN MANUEL', 6, NULL, '1985-05-21', '20-31637802-6', NULL, 'TEHUELCHES', 32, 34);
INSERT INTO persona VALUES ('DNI', 31697934, 'MAYORGA', 'ANALIA SABRINA', 26, NULL, '1985-10-02', '27-31697934-6', NULL, 'AZOPARDO', 1048, 36);
INSERT INTO persona VALUES ('DNI', 31711881, 'DOMINGUEZ', 'ADRIAN PABLO', 5, NULL, '1985-06-16', '20-31711881-7', NULL, 'PENINSULA', 652, 43);
INSERT INTO persona VALUES ('DNI', 31799287, 'JARAMILLO', 'WALTER JULIAN', 23, NULL, '1987-02-28', '20-31799287-7', NULL, 'CEFERINO', 367, 34);
INSERT INTO persona VALUES ('DNI', 31914692, 'VIDAL', 'ROCIO HILDA', 26, NULL, '1985-10-26', '27-31914692-9', NULL, 'SARGENTO', 238, 21);
INSERT INTO persona VALUES ('DNI', 31963639, 'CARDENAS', 'SANDRA HILDA', 5, NULL, '1985-12-12', '27-31963639-9', NULL, 'TEHUELCHES', 438, 38);
INSERT INTO persona VALUES ('DNI', 31985359, 'PALMA', 'MIRTHA MARIA', 6, NULL, '1986-04-08', '27-31985359-9', NULL, 'AVELLANEDA', 1380, 41);
INSERT INTO persona VALUES ('DNI', 31985648, 'AZOCAR', 'LUCIANA MARIELA', 6, NULL, '1985-12-05', '27-31985648-9', NULL, 'HOSPITAL', 1238, 15);
INSERT INTO persona VALUES ('DNI', 32084930, 'LINARES', 'MIRTHA HAYDEE', 34, NULL, '1986-06-13', '27-32084930-0', NULL, 'REMENTERIA', 1410, 14);
INSERT INTO persona VALUES ('DNI', 32142694, 'VELAZQUEZ', 'ELENA SOFIA', 4, NULL, '1986-03-19', '27-32142694-1', NULL, 'SARGENTO', 715, 14);
INSERT INTO persona VALUES ('DNI', 32169295, 'QUINTEROS', 'MAURO NAHUEL', 21, NULL, '1986-06-19', '20-32169295-1', NULL, 'CUSHAMEN', 1212, 52);
INSERT INTO persona VALUES ('DNI', 32189328, 'VALDEZ', 'NADIA AMALIA', 5, NULL, '1986-01-23', '27-32189328-1', NULL, 'CAMBACERES', 815, 28);
INSERT INTO persona VALUES ('DNI', 32189485, 'BUSTAMANTE', 'LUISA SILVINA', 5, NULL, '1986-04-14', '27-32189485-1', NULL, 'HUMPHREYS', 689, 30);
INSERT INTO persona VALUES ('DNI', 32220094, 'GARCIA', 'CAMILA ELIZABETH', 26, NULL, '1986-04-10', '27-32220094-2', NULL, 'WILLIAMS', 733, 44);
INSERT INTO persona VALUES ('DNI', 32233569, 'VARGAS', 'JONATAN NORBERTO', 6, NULL, '1986-06-03', '20-32233569-2', NULL, 'GOLONDRINAS', 179, 13);
INSERT INTO persona VALUES ('DNI', 32388506, 'SANTOS', 'MILAGROS ABRIL', 6, NULL, '1986-03-31', '27-32388506-3', NULL, 'PUEYRREDON', 1455, 55);
INSERT INTO persona VALUES ('DNI', 32429147, 'RIVAS', 'STELLA MARIANELA', 5, NULL, '1986-06-19', '27-32429147-4', NULL, 'CONSTITUYENTES', 372, 53);
INSERT INTO persona VALUES ('DNI', 32538462, 'ZARATE', 'TOMAS JULIO', 26, NULL, '1986-11-03', '20-32538462-5', NULL, 'CORRIENTES', 734, 36);
INSERT INTO persona VALUES ('DNI', 32568674, 'MANSILLA', 'ESTEBAN JONATAN', 21, NULL, '1986-09-25', '20-32568674-5', NULL, 'WILLIAMS', 236, 15);
INSERT INTO persona VALUES ('DNI', 32650030, 'LEIVA', 'MARTIN ALEXIS', 26, NULL, '1986-11-21', '20-32650030-6', NULL, 'INGENIERO', 196, 25);
INSERT INTO persona VALUES ('DNI', 32697667, 'PALACIOS', 'ANGELICA AMALIA', 6, NULL, '1986-12-22', '27-32697667-6', NULL, 'SANTIAGO', 1213, 1);
INSERT INTO persona VALUES ('DNI', 32720290, 'MONTERO', 'MARTA DIANA', 7, NULL, '1987-04-01', '27-32720290-7', NULL, 'MORETEAU', 907, 38);
INSERT INTO persona VALUES ('DNI', 32722000, 'SORIA', 'TAMARA MARIA', 6, NULL, '1987-05-07', '27-32722000-7', NULL, 'VIAMONTE', 248, 2);
INSERT INTO persona VALUES ('DNI', 32748768, 'SORIA', 'LUCIA YANINA', 9, NULL, '1987-01-25', '27-32748768-7', NULL, 'LISANDRO', 1050, 19);
INSERT INTO persona VALUES ('DNI', 32777463, 'JONES', 'FLAVIA FABIANA', 5, NULL, '1986-12-31', '27-32777463-7', NULL, 'AVELLANEDA', 282, 6);
INSERT INTO persona VALUES ('DNI', 32873808, 'MORON', 'GLORIA VICTORIA', 6, NULL, '1987-04-21', '27-32873808-8', NULL, 'INGENIERO', 261, 32);
INSERT INTO persona VALUES ('DNI', 32893019, 'GALVAN', 'LAURA MILAGROS', 34, NULL, '1987-05-21', '27-32893019-8', NULL, 'INDEPENDENCIA', 1378, 15);
INSERT INTO persona VALUES ('DNI', 32923291, 'MARQUEZ', 'GISELA GRISELDA', 6, NULL, '1987-03-04', '27-32923291-9', NULL, 'VILLARINO', 841, 38);
INSERT INTO persona VALUES ('DNI', 32954311, 'GODOY', 'GERARDO JULIAN', 5, NULL, '1987-04-11', '20-32954311-9', NULL, 'CONGRESO', 432, 31);
INSERT INTO persona VALUES ('DNI', 32954340, 'QUILODRAN', 'MAXIMILIANO FABIAN', 5, NULL, '1987-04-01', '20-32954340-9', NULL, 'CORRIENTES', 1125, 3);
INSERT INTO persona VALUES ('DNI', 32954901, 'BRUNT', 'GRACIELA ELENA', 5, NULL, '1987-09-28', '27-32954901-9', NULL, 'PENINSULA', 540, 12);
INSERT INTO persona VALUES ('DNI', 33039280, 'VALLEJOS', 'CINTIA VILMA', 5, NULL, '1987-08-14', '27-33039280-0', NULL, 'CARRENLEUFU', 474, 6);
INSERT INTO persona VALUES ('DNI', 33059038, 'MARQUEZ', 'LIDIA CAROLINA', 26, NULL, '1987-03-31', '27-33059038-0', NULL, 'CONDARCO', 402, 39);
INSERT INTO persona VALUES ('DNI', 33185278, 'ALVARADO', 'CLARA LAURA', 11, NULL, '1988-01-17', '27-33185278-1', NULL, 'CARRENLEUFU', 240, 55);
INSERT INTO persona VALUES ('DNI', 33392529, 'LONCON', 'RAMIRO MAURO', 27, NULL, '1987-08-31', '20-33392529-3', NULL, 'WILLIAMS', 1198, 40);
INSERT INTO persona VALUES ('DNI', 33392717, 'JAMES', 'CAMILA GISELA', 21, NULL, '1988-02-06', '27-33392717-3', NULL, 'TEHUELCHES', 890, 0);
INSERT INTO persona VALUES ('DNI', 33529182, 'HUGHES', 'NELIDA LILIANA', 21, NULL, '1988-04-05', '27-33529182-5', NULL, 'PORTUGAL', 614, 34);
INSERT INTO persona VALUES ('DNI', 33574918, 'CIFUENTES', 'CATALINA MORENA', 6, NULL, '1989-03-22', '27-33574918-5', NULL, 'YRIGOYEN', 1023, 22);
INSERT INTO persona VALUES ('DNI', 33616875, 'CALVO', 'NORBERTO ELIAS', 30, NULL, '1988-09-09', '20-33616875-6', NULL, 'COLOMBIA', 763, 15);
INSERT INTO persona VALUES ('DNI', 33616890, 'BAHAMONDE', 'LEONARDO ARIEL', 30, NULL, '1988-09-26', '20-33616890-6', NULL, 'INMIGRANTES', 597, 48);
INSERT INTO persona VALUES ('DNI', 33652568, 'VILLARROEL', 'GRACIELA MICAELA', 5, NULL, '1988-05-21', '27-33652568-6', NULL, 'ALMIRANTE', 689, 36);
INSERT INTO persona VALUES ('DNI', 33771513, 'FUENTEALBA', 'SEGUNDO MARIO', 4, NULL, '1988-10-11', '20-33771513-7', NULL, 'PUEYRREDON', 487, 8);
INSERT INTO persona VALUES ('DNI', 33771791, 'ZARATE', 'RAFAEL NORBERTO', 4, NULL, '1989-03-24', '20-33771791-7', NULL, 'LIBERTAD', 1032, 17);
INSERT INTO persona VALUES ('DNI', 33771876, 'BRAVO', 'DAIANA CLAUDIA', 4, NULL, '1989-04-21', '27-33771876-7', NULL, 'AMEGHINO', 859, 7);
INSERT INTO persona VALUES ('DNI', 33772202, 'CALDERON', 'VALENTINA CARMEN', 26, NULL, '1988-07-22', '27-33772202-7', NULL, 'ALMAFUERTE', 515, 53);
INSERT INTO persona VALUES ('DNI', 33775224, 'MEDINA', 'VICTOR CESAR', 23, NULL, '1990-02-10', '20-33775224-7', NULL, 'ANTARTIDA', 667, 31);
INSERT INTO persona VALUES ('DNI', 33793261, 'QUINTANA', 'CARMEN FLORENCIA', 5, NULL, '1989-02-02', '27-33793261-7', NULL, 'ALEJANDRO', 672, 3);
INSERT INTO persona VALUES ('DNI', 33946796, 'RIVAS', 'AGUSTIN MAXIMO', 21, NULL, '1989-08-04', '20-33946796-9', NULL, 'REMENTERIA', 330, 47);
INSERT INTO persona VALUES ('DNI', 33952437, 'PERALTA', 'DIANA SONIA', 6, NULL, '1988-09-27', '27-33952437-9', NULL, 'SANTIAGO', 299, 8);
INSERT INTO persona VALUES ('DNI', 34087350, 'HUENELAF', 'MARCELO CARLOS', 6, NULL, '1988-11-08', '20-34087350-0', NULL, 'LISANDRO', 1215, 18);
INSERT INTO persona VALUES ('DNI', 34144920, 'IBANEZ', 'MELISA LUCIA', 18, NULL, '1989-03-15', '27-34144920-1', NULL, 'MOLINARI', 849, 13);
INSERT INTO persona VALUES ('DNI', 34486653, 'OYARZUN', 'CARLOS RAMIRO', 5, NULL, '1989-04-08', '20-34486653-4', NULL, 'ARENALES', 950, 9);
INSERT INTO persona VALUES ('DNI', 34486688, 'NIETO', 'MARIANA FERNANDA', 5, NULL, '1989-04-13', '27-34486688-4', NULL, 'WILLIAMS', 1143, 56);
INSERT INTO persona VALUES ('DNI', 34488622, 'BRUNT', 'ANDRES ALEXIS', 26, NULL, '1989-04-20', '20-34488622-4', NULL, 'ZORRILLA', 1105, 15);
INSERT INTO persona VALUES ('DNI', 34488624, 'SANTANDER', 'CINTIA NANCY', 26, NULL, '1989-03-12', '27-34488624-4', NULL, 'PARAGUAY', 244, 28);
INSERT INTO persona VALUES ('DNI', 34488766, 'ALBORNOZ', 'SABRINA ABRIL', 21, NULL, '1989-05-12', '27-34488766-4', NULL, 'CONSTITUYENTES', 1284, 3);
INSERT INTO persona VALUES ('DNI', 34488894, 'RAMOS', 'MIRTA MARIELA', 26, NULL, '1989-06-08', '27-34488894-4', NULL, 'TRIUNVIRATO', 1015, 47);
INSERT INTO persona VALUES ('DNI', 34621905, 'BRUNT', 'MAXIMO GABRIEL', 34, NULL, '1989-05-11', '20-34621905-6', NULL, 'CASTELLI', 481, 44);
INSERT INTO persona VALUES ('DNI', 34663788, 'ACOSTA', 'VIVIANA ELVIRA', 4, NULL, '1989-12-22', '27-34663788-6', NULL, 'CORRIENTES', 302, 41);
INSERT INTO persona VALUES ('DNI', 34664242, 'LINARES', 'BRENDA LUCIANA', 5, NULL, '1989-08-30', '27-34664242-6', NULL, 'MALVINAS', 204, 19);
INSERT INTO persona VALUES ('DNI', 34667682, 'SANTOS', 'SANTIAGO HECTOR', 29, NULL, '1989-06-14', '20-34667682-6', NULL, 'GRANADEROS', 1334, 47);
INSERT INTO persona VALUES ('DNI', 34726897, 'MONTENEGRO', 'MICAELA SANDRA', 36, NULL, '1990-08-20', '27-34726897-7', NULL, 'SARGENTO', 1401, 53);
INSERT INTO persona VALUES ('DNI', 34784310, 'NIETO', 'ELIANA MIRIAM', 1, NULL, '1989-10-07', '27-34784310-7', NULL, 'GUILLERMO', 1493, 25);
INSERT INTO persona VALUES ('DNI', 34868669, 'BUSTAMANTE', 'OSCAR DANIEL', 4, NULL, '1990-01-11', '20-34868669-8', NULL, 'MOLINARI', 1051, 26);
INSERT INTO persona VALUES ('DNI', 34967321, 'IBARRA', 'FRANCISCO ROBERTO', 33, NULL, '1989-11-24', '20-34967321-9', NULL, 'TENIENTE', 961, 49);
INSERT INTO persona VALUES ('DNI', 35002167, 'ZALAZAR', 'EDGARDO RUBEN', 17, NULL, '1990-08-26', '20-35002167-0', NULL, 'OLAVARRIA', 318, 6);
INSERT INTO persona VALUES ('DNI', 35030083, 'ROSALES', 'MAURO RAMON', 5, NULL, '1989-12-15', '20-35030083-0', NULL, 'HIPOLITO', 1487, 27);
INSERT INTO persona VALUES ('DNI', 35047205, 'WILLIAMS', 'FERNANDO MATIAS', 6, NULL, '1989-09-30', '20-35047205-0', NULL, 'PENINSULA', 113, 23);
INSERT INTO persona VALUES ('DNI', 35047249, 'GUERRERO', 'FABIAN ALEXIS', 6, NULL, '1989-10-02', '20-35047249-0', NULL, 'AVELLANEDA', 797, 28);
INSERT INTO persona VALUES ('DNI', 35171950, 'FERREYRA', 'JORGE NORBERTO', 6, NULL, '1990-05-17', '20-35171950-1', NULL, 'ALMAFUERTE', 1440, 42);
INSERT INTO persona VALUES ('DNI', 35172890, 'NUNEZ', 'NATALIA MARCELA', 8, NULL, '1990-06-06', '27-35172890-1', NULL, 'RECONQUISTA', 1381, 12);
INSERT INTO persona VALUES ('DNI', 33280222, 'JONES', 'SANTIAGO LEONARDO', 29, NULL, '1987-06-07', '20-33280222-2', NULL, 'RIVADAVIA', 96, 5);
INSERT INTO persona VALUES ('DNI', 33315592, 'VILLEGAS', 'ROMINA SOFIA', 5, NULL, '1987-11-17', '27-33315592-3', NULL, 'SAAVEDRA', 554, 50);
INSERT INTO persona VALUES ('DNI', 33316018, 'MARTIN', 'RUBEN ADRIAN', 6, NULL, '1987-06-28', '20-33316018-3', NULL, 'CHACABUCO', 78, 30);
INSERT INTO persona VALUES ('DNI', 33316071, 'GONZALEZ', 'FERNANDO MATIAS', 35, NULL, '1987-07-10', '20-33316071-3', NULL, 'GOBERNADOR', 1204, 12);
INSERT INTO persona VALUES ('DNI', 33323237, 'DAVIES', 'MAXIMO CRISTIAN', 15, NULL, '1988-02-25', '20-33323237-3', NULL, 'WILLIAMS', 464, 44);
INSERT INTO persona VALUES ('DNI', 33345183, 'ALTAMIRANO', 'CAROLINA LETICIA', 26, NULL, '1987-10-28', '27-33345183-3', NULL, 'ALMAFUERTE', 1142, 1);
INSERT INTO persona VALUES ('DNI', 33345365, 'URIBE', 'MACARENA PAOLA', 26, NULL, '1987-12-11', '27-33345365-3', NULL, 'PENINSULA', 781, 15);
INSERT INTO persona VALUES ('DNI', 33355138, 'NAHUELQUIR', 'SABRINA JULIA', 5, NULL, '1988-01-09', '27-33355138-3', NULL, 'ALEJANDRO', 166, 32);
INSERT INTO persona VALUES ('DNI', 33392509, 'ALMONACID', 'MELINA ABRIL', 21, NULL, '1987-10-02', '27-33392509-3', NULL, 'TRIUNVIRATO', 925, 9);
INSERT INTO persona VALUES ('DNI', 35176552, 'MANRIQUE', 'MAIRA PATRICIA', 15, NULL, '1990-01-22', '27-35176552-1', NULL, 'CASTELLI', 1190, 32);
INSERT INTO persona VALUES ('DNI', 35218837, 'PAREDES', 'CARLOS RUBEN', 5, NULL, '1990-07-11', '20-35218837-2', NULL, 'PIETROBELLI', 875, 45);
INSERT INTO persona VALUES ('DNI', 35381326, 'PARRA', 'MARIANA DAIANA', 7, NULL, '1990-06-29', '27-35381326-3', NULL, 'TEHUELCHES', 837, 18);
INSERT INTO persona VALUES ('DNI', 35381482, 'GOMEZ', 'MELISA LUISA', 4, NULL, '1990-09-13', '27-35381482-3', NULL, 'ESCALADA', 1395, 29);
INSERT INTO persona VALUES ('DNI', 35382451, 'GEREZ', 'OSVALDO ROBERTO', 5, NULL, '1990-12-12', '20-35382451-3', NULL, 'CALAFATE', 1479, 1);
INSERT INTO persona VALUES ('DNI', 35383105, 'TORRES', 'CAROLINA ADRIANA', 6, NULL, '1990-07-02', '27-35383105-3', NULL, 'PIEDRABUENA', 856, 47);
INSERT INTO persona VALUES ('DNI', 35659009, 'GARCIA', 'IVANA PATRICIA', 6, NULL, '1991-01-11', '27-35659009-6', NULL, 'ALMAFUERTE', 1193, 32);
INSERT INTO persona VALUES ('DNI', 35659086, 'POBLETE', 'ALEJANDRO CESAR', 6, NULL, '1990-12-20', '20-35659086-6', NULL, 'HIPOLITO', 538, 48);
INSERT INTO persona VALUES ('DNI', 35886876, 'SILVA', 'NILDA ELIDA', 22, NULL, '1994-07-27', '27-35886876-8', NULL, 'TENIENTE', 1357, 31);
INSERT INTO persona VALUES ('DNI', 35888484, 'OVIEDO', 'RAQUEL STELLA', 5, NULL, '1991-09-07', '27-35888484-8', NULL, 'FOURNIER', 432, 15);
INSERT INTO persona VALUES ('DNI', 35889336, 'VILLALBA', 'ROSANA CARINA', 6, NULL, '1991-08-12', '27-35889336-8', NULL, 'ANTARTIDA', 268, 8);
INSERT INTO persona VALUES ('DNI', 35889531, 'LAGOS', 'EDITH MILAGROS', 7, NULL, '1991-06-26', '27-35889531-8', NULL, 'CANGALLO', 853, 19);
INSERT INTO persona VALUES ('DNI', 35889600, 'CATALAN', 'FABIANA LORENA', 7, NULL, '1992-01-30', '27-35889600-8', NULL, 'PIETROBELLI', 349, 9);
INSERT INTO persona VALUES ('DNI', 35889868, 'HEREDIA', 'ANDRES FELIX', 30, NULL, '1991-03-16', '20-35889868-8', NULL, 'COLOMBIA', 709, 34);
INSERT INTO persona VALUES ('DNI', 35928690, 'PRIETO', 'SILVINA NILDA', 6, NULL, '1990-11-20', '27-35928690-9', NULL, 'TUPUNGATO', 1409, 45);
INSERT INTO persona VALUES ('DNI', 36106160, 'CRESPO', 'FLORENCIA MIRTA', 28, NULL, '1990-11-12', '27-36106160-1', NULL, 'AMEGHINO', 1042, 57);
INSERT INTO persona VALUES ('DNI', 36181720, 'IGLESIAS', 'GLADIS ERICA', 18, NULL, '1991-10-30', '27-36181720-1', NULL, 'ARISTOBULO', 1147, 40);
INSERT INTO persona VALUES ('DNI', 36212878, 'SORIA', 'BRIAN RUBEN', 4, NULL, '1991-05-08', '20-36212878-2', NULL, 'VILLEGAS', 198, 13);
INSERT INTO persona VALUES ('DNI', 36647874, 'CIFUENTES', 'JONATHAN VICTOR', 6, NULL, '1993-03-18', '20-36647874-6', NULL, 'OLAVARRIA', 1038, 22);
INSERT INTO persona VALUES ('DNI', 36718873, 'EVANS', 'MARIO EMILIO', 6, NULL, '1992-03-28', '20-36718873-7', NULL, 'COLOMBIA', 1102, 9);
INSERT INTO persona VALUES ('DNI', 36719465, 'GUZMAN', 'ALDANA IRENE', 6, NULL, '1992-09-08', '27-36719465-7', NULL, 'HIPOLITO', 1274, 55);
INSERT INTO persona VALUES ('DNI', 36791907, 'PARADA', 'DEBORA MARTINA', 36, NULL, '1992-03-07', '27-36791907-7', NULL, 'QUINTANA', 1423, 34);
INSERT INTO persona VALUES ('DNI', 37006500, 'RUBILAR', 'OSCAR CLAUDIO', 5, NULL, '1992-09-03', '20-37006500-0', NULL, 'INGENIERO', 826, 14);
INSERT INTO persona VALUES ('DNI', 37067840, 'AVILES', 'LAURA MONICA', 26, NULL, '1992-08-28', '27-37067840-0', NULL, 'CORRIENTES', 189, 46);
INSERT INTO persona VALUES ('DNI', 37068029, 'GIMENEZ', 'KAREN RAQUEL', 6, NULL, '1992-09-20', '27-37068029-0', NULL, 'NECOCHEA', 582, 5);
INSERT INTO persona VALUES ('DNI', 37068721, 'SALAZAR', 'LUCIANA CARMEN', 6, NULL, '1994-07-13', '27-37068721-0', NULL, 'AZOPARDO', 70, 26);
INSERT INTO persona VALUES ('DNI', 37069026, 'JARAMILLO', 'VICTORIA CANDELA', 16, NULL, '1992-11-29', '27-37069026-0', NULL, 'TENIENTE', 1466, 31);
INSERT INTO persona VALUES ('DNI', 37147923, 'FRANCO', 'LUCIANA GLORIA', 21, NULL, '1993-09-27', '27-37147923-1', NULL, 'MISIONES', 1009, 6);
INSERT INTO persona VALUES ('DNI', 37147949, 'PERALTA', 'YAMILA LORENA', 21, NULL, '1993-10-22', '27-37147949-1', NULL, 'SARMIENTO', 1293, 40);
INSERT INTO persona VALUES ('DNI', 37147984, 'SALDIVIA', 'CESAR HERNAN', 21, NULL, '1993-11-11', '20-37147984-1', NULL, 'ALBARRACIN', 951, 4);
INSERT INTO persona VALUES ('DNI', 37148086, 'RAMOS', 'NORBERTO LUCAS', 3, NULL, '1993-12-13', '20-37148086-1', NULL, 'HONDURAS', 224, 15);
INSERT INTO persona VALUES ('DNI', 37149129, 'ZUNIGA', 'NORBERTO LUCIANO', 26, NULL, '1992-11-22', '20-37149129-1', NULL, 'PENINSULA', 1089, 14);
INSERT INTO persona VALUES ('DNI', 37149146, 'OJEDA', 'MARTIN EMANUEL', 26, NULL, '1992-11-10', '20-37149146-1', NULL, 'CAMBACERES', 1234, 48);
INSERT INTO persona VALUES ('DNI', 37149531, 'SANDOVAL', 'HILDA VICTORIA', 6, NULL, '1993-03-10', '27-37149531-1', NULL, 'ANTARTIDA', 646, 33);
INSERT INTO persona VALUES ('DNI', 37149573, 'AVILA', 'SANTIAGO FEDERICO', 6, NULL, '1993-03-21', '20-37149573-1', NULL, 'MISIONES', 222, 43);
INSERT INTO persona VALUES ('DNI', 37149762, 'TRONCOSO', 'NELSON GUILLERMO', 6, NULL, '1993-05-07', '20-37149762-1', NULL, 'ZORRILLA', 1489, 49);
INSERT INTO persona VALUES ('DNI', 37151708, 'PACHECO', 'CAROLINA HILDA', 2, NULL, '1993-05-14', '27-37151708-1', NULL, 'FEDERICCI', 1375, 21);
INSERT INTO persona VALUES ('DNI', 37154408, 'AZOCAR', 'MARCOS KEVIN', 37, NULL, '1991-03-28', '20-37154408-1', NULL, 'GUALJAINA', 754, 16);
INSERT INTO persona VALUES ('DNI', 37347319, 'MARTIN', 'JULIA VIVIANA', 4, NULL, '1993-07-29', '27-37347319-3', NULL, 'OLAVARRIA', 1459, 38);
INSERT INTO persona VALUES ('DNI', 37347611, 'RIVERA', 'CATALINA MARIELA', 30, NULL, '1993-10-13', '27-37347611-3', NULL, 'HIPOLITO', 152, 52);
INSERT INTO persona VALUES ('DNI', 37347866, 'MARQUEZ', 'LETICIA ISABEL', 5, NULL, '1994-09-21', '27-37347866-3', NULL, 'PENINSULA', 215, 31);
INSERT INTO persona VALUES ('DNI', 37550801, 'ACOSTA', 'MARISA FLAVIA', 21, NULL, '1993-07-02', '27-37550801-5', NULL, 'SARGENTO', 873, 47);
INSERT INTO persona VALUES ('DNI', 37641321, 'ORELLANA', 'NADIA CECILIA', 5, NULL, '1994-09-27', '27-37641321-6', NULL, 'TUPUNGATO', 729, 12);
INSERT INTO persona VALUES ('DNI', 37665309, 'LONCON', 'MARIANA AGUSTINA', 6, NULL, '1993-10-29', '27-37665309-6', NULL, 'AYACUCHO', 1421, 40);
INSERT INTO persona VALUES ('DNI', 37665374, 'MANRIQUEZ', 'EZEQUIEL RICARDO', 6, NULL, '1993-11-14', '20-37665374-6', NULL, 'ANTARTIDA', 186, 21);
INSERT INTO persona VALUES ('DNI', 37666304, 'VARGAS', 'VALENTINA YOLANDA', 5, NULL, '1993-09-21', '27-37666304-6', NULL, 'RIFLEROS', 121, 57);
INSERT INTO persona VALUES ('DNI', 37676641, 'CRESPO', 'SILVINA JULIETA', 10, NULL, '1994-02-09', '27-37676641-6', NULL, 'ALMAFUERTE', 1041, 38);
INSERT INTO persona VALUES ('DNI', 37676667, 'NAHUELQUIR', 'EDGARDO VICTOR', 5, NULL, '1994-03-23', '20-37676667-6', NULL, 'LIBERTAD', 924, 2);
INSERT INTO persona VALUES ('DNI', 37676847, 'AVENDANO', 'RICARDO CLAUDIO', 5, NULL, '1994-07-08', '20-37676847-6', NULL, 'INDEPENDENCIA', 702, 11);
INSERT INTO persona VALUES ('DNI', 37676898, 'EVANS', 'JOAQUIN MIGUEL', 5, NULL, '1994-07-16', '20-37676898-6', NULL, 'PECORARO', 1100, 1);
INSERT INTO persona VALUES ('DNI', 37764671, 'OVIEDO', 'HILDA MARTHA', 6, NULL, '1994-02-04', '27-37764671-7', NULL, 'MALASPINA', 225, 11);
INSERT INTO persona VALUES ('DNI', 37764772, 'PARADA', 'GLADIS LUCIANA', 6, NULL, '1993-11-22', '27-37764772-7', NULL, 'NAHUELPAN', 672, 7);
INSERT INTO persona VALUES ('DNI', 37860610, 'ALMONACID', 'CARLA NOEMI', 26, NULL, '1993-12-23', '27-37860610-8', NULL, 'SAAVEDRA', 954, 35);
INSERT INTO persona VALUES ('DNI', 37860666, 'CALDERON', 'ALEJANDRA NILDA', 26, NULL, '1993-11-25', '27-37860666-8', NULL, 'CALAFATE', 1034, 24);
INSERT INTO persona VALUES ('DNI', 37909364, 'ACOSTA', 'MARINA KAREN', 26, NULL, '1993-09-17', '27-37909364-9', NULL, 'CENTENARIO', 1098, 54);
INSERT INTO persona VALUES ('DNI', 37988265, 'EVANS', 'NESTOR GASTON', 36, NULL, '1995-03-06', '20-37988265-9', NULL, 'SARMIENTO', 468, 39);
INSERT INTO persona VALUES ('DNI', 38046207, 'ROCHA', 'ANALIA IVANA', 21, NULL, '1994-03-16', '27-38046207-0', NULL, 'ZORRILLA', 985, 50);
INSERT INTO persona VALUES ('DNI', 38046260, 'HERNANDEZ', 'AMELIA VILMA', 21, NULL, '1994-05-06', '27-38046260-0', NULL, 'MOLINARI', 160, 26);
INSERT INTO persona VALUES ('DNI', 38046492, 'NEIRA', 'NICOLAS DANIEL', 21, NULL, '1994-09-26', '20-38046492-0', NULL, 'GUILLERMO', 165, 45);
INSERT INTO persona VALUES ('DNI', 38080933, 'ARIAS', 'MERCEDES LIDIA', 9, NULL, '1994-07-24', '27-38080933-0', NULL, 'TENIENTE', 40, 32);
INSERT INTO persona VALUES ('DNI', 38147591, 'ROSAS', 'MAXIMO EMANUEL', 26, NULL, '1994-05-11', '20-38147591-1', NULL, 'HIPOLITO', 453, 30);
INSERT INTO persona VALUES ('DNI', 38232383, 'SANTANA', 'VIVIANA DEBORA', 5, NULL, '1993-02-19', '27-38232383-2', NULL, 'PUEYRREDON', 845, 1);
INSERT INTO persona VALUES ('DNI', 36320922, 'GALLARDO', 'MELINA NANCY', 14, NULL, '1992-02-20', '27-36320922-3', NULL, 'COMERCIO', 1394, 45);
INSERT INTO persona VALUES ('DNI', 36320931, 'MANRIQUEZ', 'TERESA MARGARITA', 4, NULL, '1991-11-13', '27-36320931-3', NULL, 'SARGENTO', 1323, 19);
INSERT INTO persona VALUES ('DNI', 36321774, 'ACEVEDO', 'RAFAEL MIGUEL', 5, NULL, '1992-09-07', '20-36321774-3', NULL, 'DIAGONAL', 336, 34);
INSERT INTO persona VALUES ('DNI', 36321864, 'GRIFFITHS', 'DAIANA CLARA', 5, NULL, '1992-10-25', '27-36321864-3', NULL, 'HOSPITAL', 1104, 29);
INSERT INTO persona VALUES ('DNI', 36322082, 'QUINTANA', 'HECTOR DAMIAN', 24, NULL, '1992-08-20', '20-36322082-3', NULL, 'HUMPHREYS', 923, 9);
INSERT INTO persona VALUES ('DNI', 36322225, 'ROSSI', 'YANINA DAIANA', 32, NULL, '1994-04-24', '27-36322225-3', NULL, 'O''HIGGINS', 1028, 55);
INSERT INTO persona VALUES ('DNI', 36334179, 'OLIVA', 'VICTORIA LUISA', 6, NULL, '1992-05-11', '27-36334179-3', NULL, 'FEDERICCI', 1163, 45);
INSERT INTO persona VALUES ('DNI', 31148538, 'ZALAZAR', 'CARMEN VILMA', 26, NULL, '1985-01-10', '27-31148538-1', NULL, 'RECONQUISTA', 438, 47);
INSERT INTO persona VALUES ('DNI', 31148849, 'DELGADO', 'JUANA CAROLINA', 13, NULL, '1985-03-28', '27-31148849-1', NULL, 'OLAVARRIA', 166, 48);
INSERT INTO persona VALUES ('DNI', 31211783, 'CORONADO', 'AMALIA MAIRA', 35, NULL, '1984-12-07', '27-31211783-2', NULL, 'HONDURAS', 1052, 17);
INSERT INTO persona VALUES ('DNI', 31243077, 'OJEDA', 'JOAQUIN ESTEBAN', 21, NULL, '1984-01-31', '20-31243077-2', NULL, 'COMODORO', 568, 35);
INSERT INTO persona VALUES ('DNI', 31350868, 'SAAVEDRA', 'LAUTARO WALTER', 6, NULL, '1985-05-13', '20-31350868-3', NULL, 'COMISARIA', 601, 1);
INSERT INTO persona VALUES ('DNI', 36393277, 'CAMPOS', 'AGOSTINA VANESA', 30, NULL, '1991-07-27', '27-36393277-3', NULL, 'PIEDRABUENA', 122, 57);
INSERT INTO persona VALUES ('DNI', 36393283, 'EVANS', 'GRACIELA ELIANA', 30, NULL, '1991-10-08', '27-36393283-3', NULL, 'INGENIERO', 739, 56);
INSERT INTO persona VALUES ('DNI', 36494625, 'CALDERON', 'MIRIAM LORENA', 6, NULL, '1992-03-03', '27-36494625-4', NULL, 'PIEDRABUENA', 1475, 58);
INSERT INTO persona VALUES ('DNI', 36580201, 'GUTIERREZ', 'RAMON JOAQUIN', 12, NULL, '1991-10-17', '20-36580201-5', NULL, 'RIVADAVIA', 622, 36);
INSERT INTO persona VALUES ('DNI', 38300437, 'ROSAS', 'YOLANDA GUADALUPE', 26, NULL, '1994-09-22', '27-38300437-3', NULL, 'RIFLEROS', 377, 58);
INSERT INTO persona VALUES ('DNI', 38443349, 'OLIVA', 'VICENTE PABLO', 35, NULL, '1994-07-19', '20-38443349-4', NULL, 'INMIGRANTES', 1261, 10);
INSERT INTO persona VALUES ('DNI', 38535811, 'SUAREZ', 'HILDA ESTELA', 6, NULL, '1994-11-08', '27-38535811-5', NULL, 'CONGRESO', 1235, 37);
INSERT INTO persona VALUES ('DNI', 38535815, 'ORTIZ', 'SABRINA MARINA', 4, NULL, '1994-11-05', '27-38535815-5', NULL, 'PENINSULA', 47, 9);
INSERT INTO persona VALUES ('DNI', 38711051, 'VELAZQUEZ', 'JONATHAN CLAUDIO', 5, NULL, '1995-02-14', '20-38711051-7', NULL, 'LIBERTAD', 1488, 18);
INSERT INTO persona VALUES ('DNI', 38784419, 'NUNEZ', 'BRIAN CRISTIAN', 26, NULL, '1994-12-24', '20-38784419-7', NULL, 'CASTELLI', 220, 12);
INSERT INTO persona VALUES ('DNI', 38784484, 'RIVERA', 'EZEQUIEL BRUNO', 26, NULL, '1995-02-17', '20-38784484-7', NULL, 'TENIENTE', 1344, 34);
INSERT INTO persona VALUES ('DNI', 38784653, 'CARDENAS', 'GABRIELA MARISA', 26, NULL, '1995-04-10', '27-38784653-7', NULL, 'CORCOVADO', 788, 12);
INSERT INTO persona VALUES ('DNI', 38799829, 'AVILA', 'MIRIAM ELISA', 25, NULL, '1995-03-15', '27-38799829-7', NULL, 'SOBERANIA', 1207, 52);
INSERT INTO persona VALUES ('DNI', 38801908, 'SALINAS', 'LEANDRO ADRIAN', 6, NULL, '1995-05-29', '20-38801908-8', NULL, 'CALLEJON', 257, 25);
INSERT INTO persona VALUES ('DNI', 38803935, 'ZALAZAR', 'LAURA ALEJANDRA', 26, NULL, '1995-04-03', '27-38803935-8', NULL, 'AYACUCHO', 1225, 38);
INSERT INTO persona VALUES ('DNI', 38806179, 'LUCERO', 'VICTOR ARIEL', 21, NULL, '1991-04-27', '20-38806179-8', NULL, 'ARENALES', 834, 38);
INSERT INTO persona VALUES ('DNI', 39059353, 'GALLEGOS', 'SILVINA JULIA', 6, NULL, '1995-05-17', '27-39059353-0', NULL, 'HIPOLITO', 1200, 57);
INSERT INTO persona VALUES ('DNI', 23099369, 'MONTENEGRO', 'JULIA MARIELA', 26, NULL, '1960-02-16', '27-23099369-0', NULL, 'FEDERICCI', 1326, 9);
INSERT INTO persona VALUES ('DNI', 23172838, 'VELASQUEZ', 'MARIELA ANGELICA', 26, NULL, '1960-05-24', '27-23172838-1', NULL, 'ANTARTIDA', 1098, 39);
INSERT INTO persona VALUES ('DNI', 23172855, 'QUINTEROS', 'ADRIAN JESUS', 26, NULL, '1960-05-29', '20-23172855-1', NULL, 'GOBERNADOR', 564, 43);
INSERT INTO persona VALUES ('DNI', 23547074, 'ROMERO', 'MARISA NATALIA', 26, NULL, '1961-06-04', '27-23547074-5', NULL, 'CONSTITUYENTES', 109, 28);
INSERT INTO persona VALUES ('DNI', 23569160, 'CABRERA', 'GLADYS EDITH', 26, NULL, '1961-01-26', '27-23569160-5', NULL, 'NAHUELPAN', 848, 14);
INSERT INTO persona VALUES ('DNI', 23712808, 'BARRIOS', 'ANDREA FABIANA', 26, NULL, '1960-05-16', '27-23712808-7', NULL, 'FLORENCIO', 94, 13);
INSERT INTO persona VALUES ('DNI', 23774554, 'REINOSO', 'LAUTARO EMANUEL', 21, NULL, '1961-03-22', '20-23774554-7', NULL, 'HIPOLITO', 224, 37);
INSERT INTO persona VALUES ('DNI', 23887357, 'JONES', 'ROCIO ANGELA', 21, NULL, '1961-10-24', '27-23887357-8', NULL, 'PECORARO', 208, 9);
INSERT INTO persona VALUES ('DNI', 16460835, 'CIFUENTES', 'ABRIL JULIETA', 34, NULL, '1990-10-03', '27-16460835-4', NULL, 'REMENTERIA', 1418, 58);
INSERT INTO persona VALUES ('DNI', 29836430, 'BRAVO', 'PAMELA CELIA', 26, NULL, '1983-06-13', '27-29836430-8', NULL, 'SARMIENTO', 689, 25);
INSERT INTO persona VALUES ('DNI', 29957251, 'ACUNA', 'GONZALO FABIAN', 6, NULL, '1983-07-22', '20-29957251-9', NULL, 'MISIONES', 192, 57);
INSERT INTO persona VALUES ('DNI', 29984297, 'BLANCO', 'ELIANA AMALIA', 16, NULL, '1983-07-26', '27-29984297-9', NULL, 'PUEYRREDON', 310, 16);
INSERT INTO persona VALUES ('DNI', 30008678, 'SUAREZ', 'CINTIA ANDREA', 6, NULL, '1983-12-01', '27-30008678-0', NULL, 'VILLEGAS', 303, 0);
INSERT INTO persona VALUES ('DNI', 30063150, 'PEREIRA', 'NAHUEL CRISTIAN', 31, NULL, '1983-09-30', '20-30063150-0', NULL, 'VILLEGAS', 1460, 58);
INSERT INTO persona VALUES ('DNI', 30505921, 'BARROSO', 'MELISA PAMELA', 6, NULL, '1983-11-10', '27-30505921-5', NULL, 'COMODORO', 888, 14);
INSERT INTO persona VALUES ('DNI', 30517538, 'GALLEGOS', 'ROMINA BRENDA', 26, NULL, '1983-11-12', '27-30517538-5', NULL, 'NICARAGUA', 193, 56);
INSERT INTO persona VALUES ('DNI', 30519907, 'RODRIGUEZ', 'VICTORIA MARCELA', 4, NULL, '1983-09-13', '27-30519907-5', NULL, 'CONGRESO', 457, 57);
INSERT INTO persona VALUES ('DNI', 30550115, 'VALLEJOS', 'SERGIO RODRIGO', 4, NULL, '1983-10-23', '20-30550115-5', NULL, 'ANTARTIDA', 984, 50);
INSERT INTO persona VALUES ('DNI', 30550175, 'CABRERA', 'MARISA TERESA', 4, NULL, '1983-10-29', '27-30550175-5', NULL, 'MALASPINA', 192, 55);
INSERT INTO persona VALUES ('DNI', 30550240, 'AGUERO', 'CYNTHIA TAMARA', 35, NULL, '1983-12-20', '27-30550240-5', NULL, 'FLORENCIO', 785, 8);
INSERT INTO persona VALUES ('DNI', 30550811, 'QUILODRAN', 'RICARDO MIGUEL', 24, NULL, '1984-01-18', '20-30550811-5', NULL, 'CALLEJON', 14, 27);
INSERT INTO persona VALUES ('DNI', 30550812, 'ORELLANA', 'CARINA MACARENA', 34, NULL, '1983-12-09', '27-30550812-5', NULL, 'ESCALADA', 748, 5);
INSERT INTO persona VALUES ('DNI', 30578189, 'MOLINA', 'ELISA IVANA', 4, NULL, '1984-10-18', '27-30578189-5', NULL, 'YRIGOYEN', 955, 26);
INSERT INTO persona VALUES ('DNI', 30580269, 'HUGHES', 'LETICIA CELIA', 21, NULL, '1984-05-09', '27-30580269-5', NULL, 'FOURNIER', 235, 40);
INSERT INTO persona VALUES ('DNI', 30801436, 'ROBERTS', 'MARIELA MARIANA', 6, NULL, '1985-06-21', '27-30801436-8', NULL, 'TUPUNGATO', 55, 39);
INSERT INTO persona VALUES ('DNI', 30806005, 'DOMINGUEZ', 'ANDRES MAURICIO', 5, NULL, '1984-04-23', '20-30806005-8', NULL, 'MORETEAU', 1320, 38);
INSERT INTO persona VALUES ('DNI', 30811435, 'LOPEZ', 'SUSANA VICTORIA', 4, NULL, '1984-02-09', '27-30811435-8', NULL, 'REMEDIOS', 88, 32);
INSERT INTO persona VALUES ('DNI', 30853757, 'CERDA', 'TOMAS DAVID', 19, NULL, '1984-05-22', '20-30853757-8', NULL, 'LAGUNITA', 896, 5);
INSERT INTO persona VALUES ('DNI', 30859030, 'ARANDA', 'ELIDA JULIETA', 16, NULL, '1984-08-15', '27-30859030-8', NULL, 'COLOMBIA', 145, 17);
INSERT INTO persona VALUES ('DNI', 30883617, 'GARCIA', 'JEREMIAS LUCAS', 20, NULL, '1984-03-27', '20-30883617-8', NULL, 'GOBERNADOR', 997, 11);
INSERT INTO persona VALUES ('DNI', 30883736, 'VARELA', 'MATIAS MAURICIO', 26, NULL, '1984-04-21', '20-30883736-8', NULL, 'LIBERTAD', 294, 3);
INSERT INTO persona VALUES ('DNI', 30936707, 'GARCIA', 'AMELIA LUISA', 6, NULL, '1984-11-12', '27-30936707-9', NULL, 'INMIGRANTES', 1135, 26);
INSERT INTO persona VALUES ('DNI', 30936882, 'NIETO', 'JULIAN WALTER', 6, NULL, '1984-12-24', '20-30936882-9', NULL, 'INMIGRANTES', 1383, 50);
INSERT INTO persona VALUES ('DNI', 30965345, 'ORTEGA', 'SERGIO GUILLERMO', 21, NULL, '1984-07-20', '20-30965345-9', NULL, 'QUINTANA', 1054, 46);
INSERT INTO persona VALUES ('DNI', 30976180, 'GRIFFITHS', 'GUSTAVO RODRIGO', 5, NULL, '1984-05-21', '20-30976180-9', NULL, 'HUMPHREYS', 608, 54);
INSERT INTO persona VALUES ('DNI', 30976361, 'YANEZ', 'GERMAN MAURO', 5, NULL, '1984-08-23', '20-30976361-9', NULL, 'INMIGRANTES', 601, 5);
INSERT INTO persona VALUES ('DNI', 31117929, 'MARIN', 'VILMA MICAELA', 4, NULL, '1984-12-07', '27-31117929-1', NULL, 'LISANDRO', 90, 58);
INSERT INTO persona VALUES ('DNI', 31123263, 'OYARZUN', 'MARTA CECILIA', 30, NULL, '1984-12-11', '27-31123263-1', NULL, 'ESCALADA', 1367, 31);
INSERT INTO persona VALUES ('DNI', 23887499, 'YANEZ', 'TOMAS ALEJANDRO', 21, NULL, '1962-02-03', '20-23887499-8', NULL, 'DIAGONAL', 674, 14);
INSERT INTO persona VALUES ('DNI', 23887854, 'ZARATE', 'SANTIAGO LEONARDO', 26, NULL, '1961-02-19', '20-23887854-8', NULL, 'YRIGOYEN', 1011, 57);
INSERT INTO persona VALUES ('DNI', 24212891, 'HERNANDEZ', 'DELIA JOHANA', 26, NULL, '1961-06-09', '27-24212891-2', NULL, 'CENTENARIO', 919, 56);
INSERT INTO persona VALUES ('DNI', 24637839, 'TRONCOSO', 'FABIANA CARINA', 26, NULL, '1962-03-06', '27-24637839-6', NULL, 'FEDERICCI', 132, 12);
INSERT INTO persona VALUES ('DNI', 24650524, 'DAVIES', 'EMANUEL MAURICIO', 26, NULL, '1961-12-04', '20-24650524-6', NULL, 'COMODORO', 180, 15);
INSERT INTO persona VALUES ('DNI', 24650575, 'GONZALEZ', 'RAFAEL EMILIANO', 26, NULL, '1962-01-08', '20-24650575-6', NULL, 'CEFERINO', 1325, 56);
INSERT INTO persona VALUES ('DNI', 24650693, 'GOMEZ', 'ROXANA LUCIANA', 26, NULL, '1962-01-11', '27-24650693-6', NULL, 'GOLONDRINAS', 1418, 11);
INSERT INTO persona VALUES ('DNI', 24650865, 'SANTOS', 'SILVIA MARIANELA', 26, NULL, '1962-03-18', '27-24650865-6', NULL, 'ESCALADA', 675, 29);
INSERT INTO persona VALUES ('DNI', 24650982, 'ALVAREZ', 'SILVIA CARLA', 26, NULL, '1962-04-20', '27-24650982-6', NULL, 'FRANCISCO', 858, 54);
INSERT INTO persona VALUES ('DNI', 24757164, 'BARRERA', 'DELIA VANESA', 21, NULL, '1962-06-08', '27-24757164-7', NULL, 'CENTENARIO', 1458, 9);
INSERT INTO persona VALUES ('DNI', 24757243, 'CASANOVA', 'EZEQUIEL DOMINGO', 21, NULL, '1962-07-14', '20-24757243-7', NULL, 'CONGRESO', 972, 20);
INSERT INTO persona VALUES ('DNI', 24757264, 'CASTRO', 'MONICA CAROLINA', 21, NULL, '1962-08-03', '27-24757264-7', NULL, 'HONDURAS', 907, 50);
INSERT INTO persona VALUES ('DNI', 24757407, 'ALTAMIRANO', 'IVANA LORENA', 21, NULL, '1962-10-27', '27-24757407-7', NULL, 'AZOPARDO', 1106, 17);
INSERT INTO persona VALUES ('DNI', 24757409, 'FERREYRA', 'HILDA MABEL', 21, NULL, '1962-10-30', '27-24757409-7', NULL, 'PATAGONIA', 214, 47);


--
-- Name: pk_administrativo; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY administrativo
    ADD CONSTRAINT pk_administrativo PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_alumno; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY alumno
    ADD CONSTRAINT pk_alumno PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_alumno_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY alumno_curso
    ADD CONSTRAINT pk_alumno_curso PRIMARY KEY (tipo_documento, numero_documento, anio, division, ciclo_lectivo);


--
-- Name: pk_asistencia; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT pk_asistencia PRIMARY KEY (tipo_documento, numero_documento, anio, division, ciclo_lectivo, materia, fecha);


--
-- Name: pk_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT pk_curso PRIMARY KEY (anio, division, ciclo_lectivo);


--
-- Name: pk_docente; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY docente
    ADD CONSTRAINT pk_docente PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_docente_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT pk_docente_curso PRIMARY KEY (anio, division, ciclo_lectivo, materia);


--
-- Name: pk_examen; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT pk_examen PRIMARY KEY (id);


--
-- Name: pk_examen_alumno; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT pk_examen_alumno PRIMARY KEY (tipo_doc_alumno, numero_doc_alumno, examen);


--
-- Name: pk_localidad; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY localidad
    ADD CONSTRAINT pk_localidad PRIMARY KEY (codigo);


--
-- Name: pk_materia; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY materia
    ADD CONSTRAINT pk_materia PRIMARY KEY (codigo);


--
-- Name: pk_persona; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: fk_administrativo; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_administrativo FOREIGN KEY (tipo_doc_adm, numero_doc_adm) REFERENCES administrativo(tipo_documento, numero_documento);


--
-- Name: fk_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT fk_alumno FOREIGN KEY (tipo_doc_alumno, numero_doc_alumno) REFERENCES alumno(tipo_documento, numero_documento);


--
-- Name: fk_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_alumno FOREIGN KEY (tipo_documento, numero_documento) REFERENCES alumno(tipo_documento, numero_documento);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY alumno_curso
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_curso FOREIGN KEY (curso_anio, curso_division, curso_ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_docente; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_docente FOREIGN KEY (tipo_documento, numero_documento) REFERENCES docente(tipo_documento, numero_documento);


--
-- Name: fk_es_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY alumno
    ADD CONSTRAINT fk_es_alumno FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: fk_examen; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT fk_examen FOREIGN KEY (examen) REFERENCES examen(id);


--
-- Name: fk_localidad; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT fk_localidad FOREIGN KEY (domicilio_localidad) REFERENCES localidad(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_persona; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente
    ADD CONSTRAINT fk_persona FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: fk_persona; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY administrativo
    ADD CONSTRAINT fk_persona FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: persona; Type: ACL; Schema: public; Owner: alumno
--

REVOKE ALL ON TABLE persona FROM PUBLIC;
REVOKE ALL ON TABLE persona FROM alumno;
GRANT ALL ON TABLE persona TO alumno;
GRANT ALL ON TABLE persona TO postgres;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: administrativo; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE administrativo (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL
);


ALTER TABLE public.administrativo OWNER TO alumno;

--
-- Name: alumno; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE alumno (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    fecha_ingreso date NOT NULL,
    fecha_egreso date,
    motivo_egreso text,
    CONSTRAINT alumno_motivo_egreso_check CHECK (((motivo_egreso IS NULL) OR (motivo_egreso = ANY (ARRAY['ABANDONO'::text, 'EGRESO'::text, 'EXPULSION'::text]))))
);


ALTER TABLE public.alumno OWNER TO alumno;

--
-- Name: alumno_curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE alumno_curso (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL
);


ALTER TABLE public.alumno_curso OWNER TO alumno;

--
-- Name: asistencia; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE asistencia (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL,
    materia integer NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.asistencia OWNER TO alumno;

--
-- Name: curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE curso (
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL
);


ALTER TABLE public.curso OWNER TO alumno;

--
-- Name: docente; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE docente (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    carga_horaria integer NOT NULL,
    decreto text
);


ALTER TABLE public.docente OWNER TO alumno;

--
-- Name: docente_curso; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE docente_curso (
    anio integer NOT NULL,
    division text NOT NULL,
    ciclo_lectivo integer NOT NULL,
    tipo_documento text,
    numero_documento integer,
    materia integer NOT NULL
);


ALTER TABLE public.docente_curso OWNER TO alumno;

--
-- Name: seq_examen_id; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_examen_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_examen_id OWNER TO alumno;

--
-- Name: seq_examen_id; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_examen_id', 116, true);


--
-- Name: examen; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE examen (
    materia integer NOT NULL,
    fecha date NOT NULL,
    tipo text NOT NULL,
    folio text,
    ciclo_lectivo integer NOT NULL,
    tipo_doc_adm text NOT NULL,
    numero_doc_adm integer NOT NULL,
    curso_anio integer,
    curso_division text,
    curso_ciclo_lectivo integer,
    id integer DEFAULT nextval('seq_examen_id'::regclass) NOT NULL,
    CONSTRAINT examen_tipo_check CHECK ((tipo = ANY (ARRAY['P1'::text, 'P2'::text, 'EF'::text, 'PROM'::text])))
);


ALTER TABLE public.examen OWNER TO alumno;

--
-- Name: examen_alumno; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE examen_alumno (
    tipo_doc_alumno text NOT NULL,
    numero_doc_alumno integer NOT NULL,
    nota integer,
    examen integer NOT NULL
);


ALTER TABLE public.examen_alumno OWNER TO alumno;

--
-- Name: seq_localidad_codigo; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_localidad_codigo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_localidad_codigo OWNER TO alumno;

--
-- Name: seq_localidad_codigo; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_localidad_codigo', 59, true);


--
-- Name: localidad; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE localidad (
    codigo integer DEFAULT nextval('seq_localidad_codigo'::regclass) NOT NULL,
    nombre text NOT NULL,
    provincia text,
    codigo_postal integer
);


ALTER TABLE public.localidad OWNER TO alumno;

--
-- Name: seq_materia_codigo; Type: SEQUENCE; Schema: public; Owner: alumno
--

CREATE SEQUENCE seq_materia_codigo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_materia_codigo OWNER TO alumno;

--
-- Name: seq_materia_codigo; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('seq_materia_codigo', 47, true);


--
-- Name: materia; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE materia (
    codigo integer DEFAULT nextval('seq_materia_codigo'::regclass) NOT NULL,
    nombre text NOT NULL,
    duracion text NOT NULL,
    anio integer NOT NULL,
    cuatrimestre integer,
    CONSTRAINT chk_duracion CHECK ((duracion = ANY (ARRAY['A'::text, 'C'::text]))),
    CONSTRAINT materia_anio_check CHECK ((anio = ANY (ARRAY[1, 2, 3])))
);


ALTER TABLE public.materia OWNER TO alumno;

--
-- Name: persona; Type: TABLE; Schema: public; Owner: alumno; Tablespace: 
--

CREATE TABLE persona (
    tipo_documento text NOT NULL,
    numero_documento integer NOT NULL,
    apellido text NOT NULL,
    nombre text NOT NULL,
    domicilio_localidad integer NOT NULL,
    email text,
    fecha_nacimiento date,
    cuit text NOT NULL,
    telefono text,
    domicilio_calle text,
    domicilio_altura integer,
    localidad_nacimiento integer,
    CONSTRAINT persona_cuit_check CHECK ((cuit ~ '\d{2}-\d{8}-\d'::text)),
    CONSTRAINT persona_email_check CHECK (((email IS NULL) OR (email ~ '^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$'::text))),
    CONSTRAINT persona_fecha_nac_check CHECK ((fecha_nacimiento < (now() - '18 years'::interval))),
    CONSTRAINT persona_numero_documento_check CHECK (((numero_documento >= 1000000) AND (numero_documento <= 99999999))),
    CONSTRAINT persona_tipo_documento_check CHECK ((tipo_documento = ANY (ARRAY['LE'::text, 'LC'::text, 'DNI'::text])))
);


ALTER TABLE public.persona OWNER TO alumno;

--
-- Data for Name: administrativo; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO administrativo VALUES ('DNI', 24757407);
INSERT INTO administrativo VALUES ('DNI', 24757409);


--
-- Data for Name: alumno; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO alumno VALUES ('DNI', 33280222, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33315592, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33316018, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33316071, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33323237, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33345183, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33345365, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33355138, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392509, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36320922, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36320931, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36321774, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36321864, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36322082, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36322225, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36334179, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36393277, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36393283, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36494625, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36580201, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 16460835, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29836430, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29957251, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 29984297, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30008678, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30063150, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30505921, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30517538, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30519907, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550115, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550175, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550240, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550811, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30550812, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30578189, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30580269, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30801436, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30806005, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30811435, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30853757, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30859030, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30883617, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30883736, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30936707, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30936882, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30965345, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30976180, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 30976361, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31117929, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31123263, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31148538, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31148849, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31211783, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31243077, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31350868, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31394171, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31475483, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31504713, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31587087, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31625696, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31637802, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31697934, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31711881, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31799287, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31914692, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31963639, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31985359, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 31985648, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32084930, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32142694, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32169295, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32189328, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32189485, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32220094, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32233569, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32388506, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32429147, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32538462, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32568674, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32650030, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32697667, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32720290, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32722000, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32748768, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32777463, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32873808, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32893019, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32923291, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954311, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954340, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 32954901, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33039280, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33059038, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33185278, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392529, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33392717, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33529182, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33574918, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33616875, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33616890, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33652568, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771513, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771791, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33771876, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33772202, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33775224, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33793261, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33946796, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 33952437, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34087350, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34144920, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34486653, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34486688, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488622, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488624, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488766, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34488894, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34621905, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34663788, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34664242, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34667682, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34726897, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34784310, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34868669, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 34967321, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35002167, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35030083, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35047205, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35047249, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35171950, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35172890, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35176552, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35218837, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35381326, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35381482, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35382451, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35383105, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35659009, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35659086, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35886876, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35888484, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889336, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889531, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889600, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35889868, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 35928690, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36106160, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36181720, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36212878, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36647874, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36718873, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36719465, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 36791907, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37006500, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37067840, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37068029, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37068721, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37069026, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147923, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147949, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37147984, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37148086, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149129, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149146, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149531, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149573, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37149762, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37151708, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37154408, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347319, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347611, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37347866, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37550801, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37641321, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37665309, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37665374, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37666304, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676641, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676667, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676847, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37676898, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37764671, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37764772, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37860610, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37860666, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37909364, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 37988265, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046207, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046260, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38046492, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38080933, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38147591, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38232383, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38300437, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38443349, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38535811, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38535815, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38711051, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784419, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784484, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38784653, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38799829, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38801908, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38803935, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 38806179, '2010-01-01', NULL, NULL);
INSERT INTO alumno VALUES ('DNI', 39059353, '2010-01-01', NULL, NULL);


--
-- Data for Name: alumno_curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO alumno_curso VALUES ('DNI', 35218837, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32388506, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34667682, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30801436, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149129, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33772202, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30883736, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35888484, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35382451, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30883617, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35176552, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33574918, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32893019, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32748768, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38046260, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32169295, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37069026, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32189328, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31123263, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35171950, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31148849, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35928690, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32220094, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33775224, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38799829, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34486653, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31243077, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31799287, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32720290, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33323237, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32873808, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35047205, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36321774, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37764772, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36494625, 1, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34664242, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32923291, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37147984, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30505921, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488624, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149146, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31914692, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347319, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37860666, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31985648, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35381326, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149762, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37154408, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550811, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30811435, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32777463, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38147591, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37148086, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38535815, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34621905, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35030083, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33185278, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30859030, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31148538, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347866, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36321864, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37676667, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34087350, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34726897, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37860610, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35383105, 1, '2', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 39059353, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 29984297, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550240, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36322082, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36212878, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37006500, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37676898, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35002167, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36719465, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38046492, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30580269, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30936882, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 16460835, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33771876, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36580201, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35047249, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31350868, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34486688, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38443349, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33793261, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550115, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488622, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149531, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31625696, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35889600, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 35381482, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38784484, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31963639, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31985359, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30806005, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37149573, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37641321, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30550812, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 29836430, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37068029, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33316071, 2, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30519907, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30936707, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 32538462, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36334179, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33316018, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 30008678, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36181720, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33616890, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34967321, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37347611, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 34488894, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31504713, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 33059038, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38803935, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 37666304, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 31211783, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 38806179, 3, '1', 2012);
INSERT INTO alumno_curso VALUES ('DNI', 36393277, 3, '1', 2012);


--
-- Data for Name: asistencia; Type: TABLE DATA; Schema: public; Owner: alumno
--



--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO curso VALUES (1, '1', 2012);
INSERT INTO curso VALUES (1, '2', 2012);
INSERT INTO curso VALUES (2, '1', 2012);
INSERT INTO curso VALUES (3, '1', 2012);


--
-- Data for Name: docente; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO docente VALUES ('DNI', 23099369, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23172838, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23172855, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23547074, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23569160, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23712808, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23774554, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887357, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887499, 0, NULL);
INSERT INTO docente VALUES ('DNI', 23887854, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24212891, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24637839, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650524, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650575, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650693, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650865, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24650982, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757164, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757243, 0, NULL);
INSERT INTO docente VALUES ('DNI', 24757264, 0, NULL);


--
-- Data for Name: docente_curso; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24757264, 1);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24637839, 2);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24757243, 3);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23712808, 4);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887854, 5);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172838, 6);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24212891, 7);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24650575, 8);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172838, 9);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23712808, 10);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887499, 11);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172855, 12);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 24637839, 13);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23569160, 14);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23887357, 15);
INSERT INTO docente_curso VALUES (1, '1', 2012, 'DNI', 23172855, 16);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650693, 2);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23569160, 4);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 5);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650524, 6);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650524, 7);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650693, 9);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 10);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24637839, 11);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23712808, 12);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24637839, 13);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24650982, 14);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23774554, 15);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23887499, 16);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23887357, 17);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 18);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650524, 19);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650865, 20);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 21);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23172838, 22);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23774554, 23);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 24);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23712808, 25);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650693, 26);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23712808, 27);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 28);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 29);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24212891, 30);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 31);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650865, 32);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 23547074, 33);
INSERT INTO docente_curso VALUES (2, '1', 2012, 'DNI', 24650982, 34);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24757243, 35);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887499, 36);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887357, 37);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887854, 38);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887357, 39);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650575, 41);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650982, 42);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23547074, 43);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23547074, 44);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24650524, 45);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 23887499, 46);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24212891, 47);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24757164, 1);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 24212891, 3);
INSERT INTO docente_curso VALUES (1, '2', 2012, 'DNI', 23172838, 8);
INSERT INTO docente_curso VALUES (3, '1', 2012, 'DNI', 24637839, 40);


--
-- Data for Name: examen; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO examen VALUES (1, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 1);
INSERT INTO examen VALUES (1, '2012-11-06', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 2);
INSERT INTO examen VALUES (2, '2012-06-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 3);
INSERT INTO examen VALUES (2, '2012-10-21', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 4);
INSERT INTO examen VALUES (3, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 5);
INSERT INTO examen VALUES (3, '2012-11-09', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 6);
INSERT INTO examen VALUES (4, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 7);
INSERT INTO examen VALUES (4, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 8);
INSERT INTO examen VALUES (5, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 9);
INSERT INTO examen VALUES (5, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 10);
INSERT INTO examen VALUES (7, '2012-05-27', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 11);
INSERT INTO examen VALUES (7, '2012-11-16', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 12);
INSERT INTO examen VALUES (8, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 13);
INSERT INTO examen VALUES (8, '2012-10-18', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 14);
INSERT INTO examen VALUES (12, '2012-05-14', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 15);
INSERT INTO examen VALUES (12, '2012-11-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 16);
INSERT INTO examen VALUES (13, '2012-06-11', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 17);
INSERT INTO examen VALUES (13, '2012-11-18', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 18);
INSERT INTO examen VALUES (14, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 19);
INSERT INTO examen VALUES (14, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 20);
INSERT INTO examen VALUES (15, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 21);
INSERT INTO examen VALUES (15, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 22);
INSERT INTO examen VALUES (17, '2012-05-30', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 23);
INSERT INTO examen VALUES (17, '2012-10-25', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 24);
INSERT INTO examen VALUES (18, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 25);
INSERT INTO examen VALUES (18, '2012-10-20', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 26);
INSERT INTO examen VALUES (20, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 27);
INSERT INTO examen VALUES (20, '2012-11-04', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 28);
INSERT INTO examen VALUES (21, '2012-05-19', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 29);
INSERT INTO examen VALUES (21, '2012-11-08', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 30);
INSERT INTO examen VALUES (22, '2012-06-08', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 31);
INSERT INTO examen VALUES (22, '2012-10-25', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 32);
INSERT INTO examen VALUES (23, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 33);
INSERT INTO examen VALUES (23, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 34);
INSERT INTO examen VALUES (24, '2012-05-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 35);
INSERT INTO examen VALUES (24, '2012-11-17', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 36);
INSERT INTO examen VALUES (25, '2012-05-24', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 37);
INSERT INTO examen VALUES (25, '2012-10-24', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 38);
INSERT INTO examen VALUES (26, '2012-06-07', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 39);
INSERT INTO examen VALUES (26, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 40);
INSERT INTO examen VALUES (27, '2012-06-14', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 41);
INSERT INTO examen VALUES (27, '2012-11-04', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 42);
INSERT INTO examen VALUES (28, '2012-05-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 43);
INSERT INTO examen VALUES (28, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 44);
INSERT INTO examen VALUES (29, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 45);
INSERT INTO examen VALUES (29, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 46);
INSERT INTO examen VALUES (30, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 47);
INSERT INTO examen VALUES (30, '2012-11-11', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 48);
INSERT INTO examen VALUES (31, '2012-05-13', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 49);
INSERT INTO examen VALUES (31, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 50);
INSERT INTO examen VALUES (32, '2012-05-13', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 51);
INSERT INTO examen VALUES (32, '2012-11-02', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 52);
INSERT INTO examen VALUES (34, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 53);
INSERT INTO examen VALUES (34, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 54);
INSERT INTO examen VALUES (37, '2012-05-10', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 55);
INSERT INTO examen VALUES (37, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 56);
INSERT INTO examen VALUES (38, '2012-06-07', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 57);
INSERT INTO examen VALUES (38, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 58);
INSERT INTO examen VALUES (40, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 59);
INSERT INTO examen VALUES (40, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 60);
INSERT INTO examen VALUES (42, '2012-05-21', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 61);
INSERT INTO examen VALUES (42, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 62);
INSERT INTO examen VALUES (43, '2012-05-22', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 63);
INSERT INTO examen VALUES (43, '2012-10-23', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 64);
INSERT INTO examen VALUES (44, '2012-05-25', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 65);
INSERT INTO examen VALUES (44, '2012-11-03', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 66);
INSERT INTO examen VALUES (46, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 67);
INSERT INTO examen VALUES (47, '2012-05-14', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 68);
INSERT INTO examen VALUES (47, '2012-10-27', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 69);
INSERT INTO examen VALUES (6, '2012-04-12', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 70);
INSERT INTO examen VALUES (6, '2012-06-07', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 71);
INSERT INTO examen VALUES (9, '2012-04-03', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 72);
INSERT INTO examen VALUES (9, '2012-05-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 73);
INSERT INTO examen VALUES (10, '2012-04-05', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 74);
INSERT INTO examen VALUES (10, '2012-06-10', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 75);
INSERT INTO examen VALUES (19, '2012-04-09', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 76);
INSERT INTO examen VALUES (19, '2012-05-27', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 77);
INSERT INTO examen VALUES (35, '2012-04-06', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 78);
INSERT INTO examen VALUES (35, '2012-05-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 79);
INSERT INTO examen VALUES (36, '2012-04-02', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 80);
INSERT INTO examen VALUES (36, '2012-05-29', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 81);
INSERT INTO examen VALUES (1, '2012-05-16', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 82);
INSERT INTO examen VALUES (1, '2012-11-03', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 83);
INSERT INTO examen VALUES (2, '2012-05-22', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 84);
INSERT INTO examen VALUES (2, '2012-10-31', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 85);
INSERT INTO examen VALUES (3, '2012-05-20', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 86);
INSERT INTO examen VALUES (3, '2012-10-24', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 87);
INSERT INTO examen VALUES (4, '2012-06-13', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 88);
INSERT INTO examen VALUES (4, '2012-11-16', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 89);
INSERT INTO examen VALUES (5, '2012-05-26', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 90);
INSERT INTO examen VALUES (5, '2012-11-17', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 91);
INSERT INTO examen VALUES (7, '2012-06-08', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 92);
INSERT INTO examen VALUES (7, '2012-11-20', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 93);
INSERT INTO examen VALUES (8, '2012-06-01', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 94);
INSERT INTO examen VALUES (8, '2012-11-05', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 95);
INSERT INTO examen VALUES (12, '2012-06-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 96);
INSERT INTO examen VALUES (12, '2012-11-12', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 97);
INSERT INTO examen VALUES (13, '2012-06-09', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 98);
INSERT INTO examen VALUES (13, '2012-10-20', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 99);
INSERT INTO examen VALUES (14, '2012-06-14', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 100);
INSERT INTO examen VALUES (14, '2012-10-17', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 101);
INSERT INTO examen VALUES (15, '2012-05-12', 'P1', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 102);
INSERT INTO examen VALUES (15, '2012-11-23', 'P2', NULL, 2012, 'DNI', 24757409, 1, '2', 2012, 103);
INSERT INTO examen VALUES (45, '2012-05-29', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 104);
INSERT INTO examen VALUES (45, '2012-11-09', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 105);
INSERT INTO examen VALUES (46, '2012-06-05', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 106);
INSERT INTO examen VALUES (11, '2012-08-28', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 107);
INSERT INTO examen VALUES (11, '2012-11-10', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 108);
INSERT INTO examen VALUES (16, '2012-09-02', 'P1', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 109);
INSERT INTO examen VALUES (16, '2012-10-28', 'P2', NULL, 2012, 'DNI', 24757409, 1, '1', 2012, 110);
INSERT INTO examen VALUES (33, '2012-08-30', 'P1', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 111);
INSERT INTO examen VALUES (33, '2012-10-26', 'P2', NULL, 2012, 'DNI', 24757409, 2, '1', 2012, 112);
INSERT INTO examen VALUES (39, '2012-09-02', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 113);
INSERT INTO examen VALUES (39, '2012-10-30', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 114);
INSERT INTO examen VALUES (41, '2012-09-09', 'P1', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 115);
INSERT INTO examen VALUES (41, '2012-11-08', 'P2', NULL, 2012, 'DNI', 24757409, 3, '1', 2012, 116);


--
-- Data for Name: examen_alumno; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 4);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 10, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30801436, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 2, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37149129, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 10, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33772202, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 10, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35382451, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 73);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 22);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 5);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35176552, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 5, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33574918, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 10, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32748768, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 75);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 74);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 73);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 71);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 70);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 22);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 11);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 8);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 2, 7);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 38046260, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32169295, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 2, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 2, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 3, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37069026, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32189328, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 3, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 2, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31123263, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35171950, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 3, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 2, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31148849, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 9, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 10, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 3, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32220094, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33775224, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 73);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 71);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 70);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 19);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 12);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 8);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 9, 4);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 38799829, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 16);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 7);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 34486653, 7, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31243077, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 10);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 10, 6);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 5);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 8, 3);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 9, 2);
INSERT INTO examen_alumno VALUES ('DNI', 31799287, 6, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32720290, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 110);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 72);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 71);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 22);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 16);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 15);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 6);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 4, 4);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 7, 2);
INSERT INTO examen_alumno VALUES ('DNI', 33323237, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 10, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 9, 1);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 2, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 4, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35047205, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 108);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 107);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 72);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 70);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 21);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 15);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 13);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 11);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 9);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 7, 7);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 3, 6);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 36321774, 5, 1);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 107);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 75);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 74);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 19);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 18);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 16);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 15);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 14);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 13);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 12);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 10, 8);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 7);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 6);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 7, 5);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 37764772, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 110);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 109);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 108);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 107);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 74);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 73);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 72);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 71);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 4, 70);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 22);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 19);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 18);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 16);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 12);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 11);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 9);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 6);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 4);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 5, 3);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 8, 2);
INSERT INTO examen_alumno VALUES ('DNI', 36494625, 4, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34664242, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 95);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 94);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 5, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 2, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37147984, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30505921, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34488624, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 3, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37149146, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37347319, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 9, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 6, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35381326, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 2, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37149762, 2, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37154408, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 9, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30550811, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 10, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30811435, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 96);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 94);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 93);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 9, 92);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 90);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 89);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 32777463, 10, 82);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 97);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 5, 83);
INSERT INTO examen_alumno VALUES ('DNI', 38147591, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 3, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 2, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37148086, 5, 82);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 90);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 38535815, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 7, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 8, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 9, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34621905, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 2, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35030083, 3, 82);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 90);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 84);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 33185278, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 103);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 102);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 100);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 99);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 95);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 92);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 9, 82);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 103);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 102);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 100);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 99);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 2, 98);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 94);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 5, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 89);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 5, 86);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 2, 85);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 3, 84);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 31148538, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 8, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 7, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37347866, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 102);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 101);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 98);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 97);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 91);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 89);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 6, 88);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 86);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 5, 85);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 3, 83);
INSERT INTO examen_alumno VALUES ('DNI', 36321864, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 37676667, 8, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 2, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 2, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 3, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 6, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 5, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34087350, 4, 82);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 102);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 101);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 100);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 99);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 98);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 97);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 96);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 93);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 7, 90);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 88);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 87);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 86);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 9, 85);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 84);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 8, 83);
INSERT INTO examen_alumno VALUES ('DNI', 34726897, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 103);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 102);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 101);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 100);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 98);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 97);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 96);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 95);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 93);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 8, 92);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 89);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 88);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 9, 86);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 85);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 10, 84);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 103);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 102);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 101);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 100);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 99);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 98);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 95);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 8, 94);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 93);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 92);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 91);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 90);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 89);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 88);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 5, 87);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 6, 86);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 4, 85);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 84);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 83);
INSERT INTO examen_alumno VALUES ('DNI', 35383105, 7, 82);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 112);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 2, 111);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 52);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 45);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 38);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 35);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 2, 34);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 39059353, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 112);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 54);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 37);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 30);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550240, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36322082, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 4, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36212878, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 2, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37006500, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 8, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37676898, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 2, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35002167, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36719465, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38046492, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30580269, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 51);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 47);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 33);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 29);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 16460835, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 10, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33771876, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 43);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 36580201, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 2, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 2, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35047249, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31350868, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 35);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 34486688, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 8, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38443349, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33793261, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550115, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 54);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 34488622, 7, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 2, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 6, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 3, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37149531, 4, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31625696, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 111);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 77);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 51);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 38);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 8, 29);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 6, 26);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 35381482, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 112);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 76);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 53);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 52);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 45);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 10, 37);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 36);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 33);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 31);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 28);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 7, 27);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 8, 25);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 6, 24);
INSERT INTO examen_alumno VALUES ('DNI', 38784484, 9, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 7, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 112);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 76);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 51);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 48);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 47);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 41);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 40);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 37);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 36);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 35);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 34);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 32);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 30);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 25);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 9, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30806005, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 2, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 4, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37149573, 5, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 9, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 7, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37641321, 8, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 112);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 54);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 48);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 47);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 46);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 43);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 42);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 41);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 40);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 39);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 38);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 37);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 36);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 35);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 34);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 33);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 32);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 30);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 27);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 7, 26);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 5, 25);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 9, 24);
INSERT INTO examen_alumno VALUES ('DNI', 30550812, 6, 23);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 112);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 111);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 77);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 76);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 54);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 53);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 52);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 49);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 48);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 47);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 46);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 45);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 43);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 42);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 41);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 40);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 39);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 38);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 37);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 36);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 35);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 34);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 33);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 32);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 7, 31);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 30);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 29);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 28);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 8, 27);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 9, 26);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 25);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 24);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 10, 23);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 111);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 77);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 76);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 54);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 53);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 52);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 50);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 49);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 48);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 47);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 46);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 45);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 44);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 43);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 42);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 41);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 40);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 39);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 37);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 36);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 35);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 34);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 6, 33);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 32);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 30);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 29);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 4, 28);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 26);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 3, 25);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 37068029, 2, 23);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 112);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 111);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 77);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 76);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 54);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 53);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 52);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 50);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 49);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 48);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 47);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 46);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 44);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 43);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 7, 42);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 41);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 40);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 39);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 38);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 37);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 36);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 35);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 34);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 33);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 31);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 30);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 28);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 27);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 26);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 4, 25);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 5, 24);
INSERT INTO examen_alumno VALUES ('DNI', 33316071, 3, 23);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30519907, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 10, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 9, 55);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 113);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 105);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 79);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 65);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 8, 56);
INSERT INTO examen_alumno VALUES ('DNI', 32538462, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 58);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 108);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 75);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 73);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 22);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 21);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 19);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 17);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 7, 16);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 15);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 11);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 10);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 8);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 5, 7);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 5);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 4, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35218837, 3, 1);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 4, 109);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 108);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 107);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 4, 75);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 73);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 70);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 22);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 21);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 19);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 16);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 15);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 14);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 13);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 12);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 11);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 10);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 9);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 8);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 7);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 6, 6);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 5);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 7, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 5, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32388506, 8, 1);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 110);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 109);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 108);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 107);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 75);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 74);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 73);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 72);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 71);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 22);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 21);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 20);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 19);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 18);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 17);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 10, 16);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 7, 15);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 14);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 13);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 12);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 11);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 9, 10);
INSERT INTO examen_alumno VALUES ('DNI', 34667682, 8, 9);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 70);
INSERT INTO examen_alumno VALUES ('DNI', 30883736, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 110);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 109);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 74);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 18);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 35888484, 6, 12);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 75);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 71);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 13);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 10);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 8);
INSERT INTO examen_alumno VALUES ('DNI', 30883617, 6, 4);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 17);
INSERT INTO examen_alumno VALUES ('DNI', 32893019, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 72);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 14);
INSERT INTO examen_alumno VALUES ('DNI', 35928690, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 20);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 3);
INSERT INTO examen_alumno VALUES ('DNI', 32873808, 6, 2);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 97);
INSERT INTO examen_alumno VALUES ('DNI', 32923291, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 101);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 96);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 95);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 93);
INSERT INTO examen_alumno VALUES ('DNI', 31914692, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 37860666, 6, 92);
INSERT INTO examen_alumno VALUES ('DNI', 31985648, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 6, 91);
INSERT INTO examen_alumno VALUES ('DNI', 30859030, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 99);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 94);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 90);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 87);
INSERT INTO examen_alumno VALUES ('DNI', 37860610, 6, 82);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 48);
INSERT INTO examen_alumno VALUES ('DNI', 29984297, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 77);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 52);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 49);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 30936882, 6, 32);
INSERT INTO examen_alumno VALUES ('DNI', 35889600, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 6, 31);
INSERT INTO examen_alumno VALUES ('DNI', 31963639, 6, 29);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 6, 45);
INSERT INTO examen_alumno VALUES ('DNI', 31985359, 6, 44);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 6, 51);
INSERT INTO examen_alumno VALUES ('DNI', 29836430, 6, 50);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30936707, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 6, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36334179, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 3, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33316018, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 116);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 115);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 114);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 113);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 106);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 105);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 104);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 81);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 79);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 78);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 69);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 68);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 66);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 65);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 64);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 2, 62);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 60);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 4, 59);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 5, 57);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 3, 56);
INSERT INTO examen_alumno VALUES ('DNI', 30008678, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 3, 58);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36181720, 4, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33616890, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 115);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 113);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 104);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 81);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 80);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 67);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 66);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 62);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 58);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 10, 57);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 34967321, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 116);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 114);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 104);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 81);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 79);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 68);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 64);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 6, 61);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 57);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 4, 56);
INSERT INTO examen_alumno VALUES ('DNI', 37347611, 5, 55);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 116);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 8, 106);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 105);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 65);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 64);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 5, 61);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 59);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 56);
INSERT INTO examen_alumno VALUES ('DNI', 34488894, 7, 55);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 116);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 113);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 106);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 105);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 104);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 81);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 79);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 65);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 9, 64);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 63);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 61);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 60);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 59);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 31504713, 8, 55);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 116);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 114);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 113);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 6, 106);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 105);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 104);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 6, 80);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 79);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 78);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 69);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 68);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 66);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 3, 62);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 61);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 60);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 59);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 58);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 2, 57);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 33059038, 4, 55);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 116);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 115);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 105);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 104);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 81);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 79);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 78);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 69);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 67);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 66);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 65);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 64);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 10, 63);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 61);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 59);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 9, 58);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 6, 57);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 8, 56);
INSERT INTO examen_alumno VALUES ('DNI', 38803935, 7, 55);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 116);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 115);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 114);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 113);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 105);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 81);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 8, 78);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 69);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 66);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 65);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 63);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 62);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 58);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 7, 57);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 37666304, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 116);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 115);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 114);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 113);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 106);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 105);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 80);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 79);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 7, 78);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 69);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 68);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 67);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 66);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 65);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 64);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 63);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 5, 62);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 61);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 60);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 59);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 3, 58);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 4, 57);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 56);
INSERT INTO examen_alumno VALUES ('DNI', 31211783, 6, 55);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 115);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 114);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 113);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 106);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 105);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 104);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 81);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 80);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 79);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 6, 78);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 69);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 68);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 7, 67);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 66);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 65);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 63);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 62);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 61);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 9, 60);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 59);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 58);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 56);
INSERT INTO examen_alumno VALUES ('DNI', 38806179, 10, 55);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 116);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 115);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 114);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 113);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 106);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 105);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 104);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 81);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 80);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 79);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 78);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 69);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 68);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 67);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 66);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 65);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 64);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 4, 63);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 6, 62);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 61);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 7, 60);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 59);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 58);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 8, 57);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 5, 56);
INSERT INTO examen_alumno VALUES ('DNI', 36393277, 6, 55);


--
-- Data for Name: localidad; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO localidad VALUES (1, 'PASO DE INDIOS', NULL, NULL);
INSERT INTO localidad VALUES (2, 'CAMARONES', NULL, NULL);
INSERT INTO localidad VALUES (3, 'PASO DEL SAPO', NULL, NULL);
INSERT INTO localidad VALUES (4, 'ESQUEL', NULL, NULL);
INSERT INTO localidad VALUES (5, 'PUERTO MADRYN', NULL, NULL);
INSERT INTO localidad VALUES (6, 'COMODORO RIVADAVIA', NULL, NULL);
INSERT INTO localidad VALUES (7, 'TREVELIN', NULL, NULL);
INSERT INTO localidad VALUES (8, 'MARTINEZ', NULL, NULL);
INSERT INTO localidad VALUES (9, 'JOSE DE SAN MARTIN', NULL, NULL);
INSERT INTO localidad VALUES (10, 'GASTRE', NULL, NULL);
INSERT INTO localidad VALUES (11, 'LAGO PUELO', NULL, NULL);
INSERT INTO localidad VALUES (12, 'TECKA', NULL, NULL);
INSERT INTO localidad VALUES (13, 'GAN-GAN', NULL, NULL);
INSERT INTO localidad VALUES (14, 'CARRENLEUFU', NULL, NULL);
INSERT INTO localidad VALUES (15, 'EL MAITEN', NULL, NULL);
INSERT INTO localidad VALUES (16, 'RIO PICO', NULL, NULL);
INSERT INTO localidad VALUES (17, 'PUERTO PIRAMIDE', NULL, NULL);
INSERT INTO localidad VALUES (18, 'RADA TILLY', NULL, NULL);
INSERT INTO localidad VALUES (19, 'DR. RICARDO ROJAS', NULL, NULL);
INSERT INTO localidad VALUES (21, 'RAWSON', NULL, NULL);
INSERT INTO localidad VALUES (22, 'CUSHAMEN', NULL, NULL);
INSERT INTO localidad VALUES (23, 'LAS PLUMAS', NULL, NULL);
INSERT INTO localidad VALUES (24, 'DOLAVON', NULL, NULL);
INSERT INTO localidad VALUES (25, 'GUALJAINA', NULL, NULL);
INSERT INTO localidad VALUES (26, 'TRELEW', NULL, NULL);
INSERT INTO localidad VALUES (28, 'RIO MAYO', NULL, NULL);
INSERT INTO localidad VALUES (29, 'EPUYEN', NULL, NULL);
INSERT INTO localidad VALUES (30, 'SARMIENTO', NULL, NULL);
INSERT INTO localidad VALUES (31, 'CORCOVADO', NULL, NULL);
INSERT INTO localidad VALUES (32, 'FACUNDO', NULL, NULL);
INSERT INTO localidad VALUES (33, 'EL BOLSON', NULL, NULL);
INSERT INTO localidad VALUES (34, 'GAIMAN', NULL, NULL);
INSERT INTO localidad VALUES (35, 'PLAYA UNION', NULL, NULL);
INSERT INTO localidad VALUES (36, 'ALTO RIO SENGUER', NULL, NULL);
INSERT INTO localidad VALUES (37, 'EL HOYO', NULL, NULL);
INSERT INTO localidad VALUES (38, 'CORDOBA', NULL, NULL);
INSERT INTO localidad VALUES (39, 'LELEQUE', NULL, NULL);
INSERT INTO localidad VALUES (40, 'CHOLILA', NULL, NULL);
INSERT INTO localidad VALUES (41, 'GARAYALDE', NULL, NULL);
INSERT INTO localidad VALUES (42, 'CERRO CENTINELA', NULL, NULL);
INSERT INTO localidad VALUES (43, 'BUEN PASTO', NULL, NULL);
INSERT INTO localidad VALUES (44, 'GOBERNADOR COSTA', NULL, NULL);
INSERT INTO localidad VALUES (45, 'DEPARTAMENTO CUSHAMEN', NULL, NULL);
INSERT INTO localidad VALUES (46, 'LAS GOLONDRINAS', NULL, NULL);
INSERT INTO localidad VALUES (47, 'GENERAL MOSCONI (KM3)', NULL, NULL);
INSERT INTO localidad VALUES (48, 'SEPAUCAL', NULL, NULL);
INSERT INTO localidad VALUES (49, 'SAN LUIS', NULL, NULL);
INSERT INTO localidad VALUES (50, 'VILLA CARLOS PAZ', NULL, NULL);
INSERT INTO localidad VALUES (51, 'SAN RAFAEL', NULL, NULL);
INSERT INTO localidad VALUES (52, 'LA PLATA', NULL, NULL);
INSERT INTO localidad VALUES (53, 'COMANDANTE LUIS PIEDRABUENA', NULL, NULL);
INSERT INTO localidad VALUES (54, 'RAFAELA', NULL, NULL);
INSERT INTO localidad VALUES (57, 'WILDE', NULL, NULL);
INSERT INTO localidad VALUES (58, 'LANGUIÑEO', NULL, NULL);
INSERT INTO localidad VALUES (59, '25 DE MAYO', 'CHUBUT', 0);
INSERT INTO localidad VALUES (55, 'ADROGUE', 'CHUBUT', 0);
INSERT INTO localidad VALUES (56, 'BUENOS AIRES', '-', 0);
INSERT INTO localidad VALUES (27, 'CAPITAL FEDERAL', '-', 0);
INSERT INTO localidad VALUES (20, 'CIUDAD AUTONOMA DE BS. AS.', '-', 0);


--
-- Data for Name: materia; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO materia VALUES (1, 'FILOSOFIA Y ETICA', 'A', 1, NULL);
INSERT INTO materia VALUES (2, 'COMUNICACIÓN SOCIAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (3, 'PROBLEMÁTICA SOCIO-CULTURAL CONTEMPORANEA', 'A', 1, NULL);
INSERT INTO materia VALUES (4, 'PSICOLOGÍA', 'A', 1, NULL);
INSERT INTO materia VALUES (5, 'INGLES TECNICO', 'A', 1, NULL);
INSERT INTO materia VALUES (7, 'DEFENSA PERSONAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (8, 'ORGANIZACIÓN Y LEGISLACION POLICIAL I', 'A', 1, NULL);
INSERT INTO materia VALUES (12, 'EDUCACION FISICA I', 'A', 1, NULL);
INSERT INTO materia VALUES (13, 'DERECHO CONSTITUCIONAL', 'A', 1, NULL);
INSERT INTO materia VALUES (14, 'DERECHO PENAL', 'A', 1, NULL);
INSERT INTO materia VALUES (15, 'DERECHO PROCESAL PENAL', 'A', 1, NULL);
INSERT INTO materia VALUES (17, 'RELACIONES HUMANAS', 'A', 2, NULL);
INSERT INTO materia VALUES (18, 'COMUNICACIÓN SOCIAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (20, 'PSICOLOGIA CRIMINAL', 'A', 2, NULL);
INSERT INTO materia VALUES (21, 'EDI (INVESTIGACION CRIMINAL)', 'A', 2, NULL);
INSERT INTO materia VALUES (22, 'DERECHO PENAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (23, 'DERECHO PROCESAL PENAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (24, 'METODOLOGIA DE INVESTIGACION I', 'A', 2, NULL);
INSERT INTO materia VALUES (25, 'EDUCACION FISICA II', 'A', 2, NULL);
INSERT INTO materia VALUES (26, 'MEDICINA LEGAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (27, 'ARMAS Y TIRO I', 'A', 2, NULL);
INSERT INTO materia VALUES (28, 'DEFENSA PERSONAL II', 'A', 2, NULL);
INSERT INTO materia VALUES (29, 'SEGURIDAD PUBLICA I', 'A', 2, NULL);
INSERT INTO materia VALUES (30, 'ORGANIZACIÓN Y LEG. PCIAL. II', 'A', 2, NULL);
INSERT INTO materia VALUES (31, 'TECNICA DE PROCEDIMIENTOS POLICIALES', 'A', 2, NULL);
INSERT INTO materia VALUES (32, 'ACTUACION PREVENCIONAL I', 'A', 2, NULL);
INSERT INTO materia VALUES (34, 'CRIMINALISTICA', 'A', 2, NULL);
INSERT INTO materia VALUES (37, 'DERECHO ADMINISTRATIVO', 'A', 3, NULL);
INSERT INTO materia VALUES (38, 'METODOLOGIA DE LA INVESTIGACION II', 'A', 3, NULL);
INSERT INTO materia VALUES (40, 'PLANEAMIENTO ESTRATEGICO II', 'A', 3, NULL);
INSERT INTO materia VALUES (42, 'ARMAS Y TIRO II', 'A', 3, NULL);
INSERT INTO materia VALUES (43, 'PREVENCION COMUNITARIA DE LA VIOLENCIA', 'A', 3, NULL);
INSERT INTO materia VALUES (44, 'SEGURIDAD PUBLICA II', 'A', 3, NULL);
INSERT INTO materia VALUES (45, 'CRIMINOLOGIA', 'A', 3, NULL);
INSERT INTO materia VALUES (46, 'ACTUACION PREVENCIONAL II', 'A', 3, NULL);
INSERT INTO materia VALUES (47, 'EDI ( DERECHOS HUMANOS)', 'A', 3, NULL);
INSERT INTO materia VALUES (6, 'EDI (PROTOCOLO – CEREMONIAL)', 'C', 1, 1);
INSERT INTO materia VALUES (9, 'INTRODUCCION A LA SEGURIDAD PUBLICA', 'C', 1, 1);
INSERT INTO materia VALUES (10, 'MEDICINA LEGAL I', 'C', 1, 1);
INSERT INTO materia VALUES (19, 'PLANEAMIENTO ESTRATEGICO I', 'C', 2, 1);
INSERT INTO materia VALUES (35, 'SOCIEDAD', 'C', 3, 1);
INSERT INTO materia VALUES (36, 'ETICA PROFESIONAL', 'C', 3, 1);
INSERT INTO materia VALUES (11, 'BIOSEGURIDAD Y PRIMEROS AUXILIOS', 'C', 1, 2);
INSERT INTO materia VALUES (16, 'EDI (psicología evaluativa del arma)', 'C', 1, 2);
INSERT INTO materia VALUES (33, 'EDI', 'C', 2, 2);
INSERT INTO materia VALUES (39, 'PROTECCION CONTRA SINIESTROS', 'C', 3, 2);
INSERT INTO materia VALUES (41, 'EDI (DEFENSA PERSONAL POLICIAL Y USO DE TONFA)', 'C', 3, 2);


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: alumno
--

INSERT INTO persona VALUES ('DNI', 31394171, 'PEREYRA', 'JULIETA FERNANDA', 6, NULL, '1985-09-04', '27-31394171-3', NULL, 'ESCALADA', 847, 55);
INSERT INTO persona VALUES ('DNI', 31475483, 'CIFUENTES', 'NELSON OSCAR', 30, NULL, '1985-08-10', '20-31475483-4', NULL, 'COMERCIO', 800, 32);
INSERT INTO persona VALUES ('DNI', 31504713, 'SAAVEDRA', 'KAREN JOHANA', 21, NULL, '1985-02-26', '27-31504713-5', NULL, 'ARISTOBULO', 1026, 58);
INSERT INTO persona VALUES ('DNI', 31587087, 'ALVAREZ', 'MAURO CRISTIAN', 18, NULL, '1986-03-02', '20-31587087-5', NULL, 'DIAGONAL', 949, 47);
INSERT INTO persona VALUES ('DNI', 31625696, 'LEDESMA', 'FACUNDO LUCIANO', 5, NULL, '1985-06-30', '20-31625696-6', NULL, 'ESCALADA', 288, 33);
INSERT INTO persona VALUES ('DNI', 31637802, 'ORTEGA', 'SEBASTIAN MANUEL', 6, NULL, '1985-05-21', '20-31637802-6', NULL, 'TEHUELCHES', 32, 34);
INSERT INTO persona VALUES ('DNI', 31697934, 'MAYORGA', 'ANALIA SABRINA', 26, NULL, '1985-10-02', '27-31697934-6', NULL, 'AZOPARDO', 1048, 36);
INSERT INTO persona VALUES ('DNI', 31711881, 'DOMINGUEZ', 'ADRIAN PABLO', 5, NULL, '1985-06-16', '20-31711881-7', NULL, 'PENINSULA', 652, 43);
INSERT INTO persona VALUES ('DNI', 31799287, 'JARAMILLO', 'WALTER JULIAN', 23, NULL, '1987-02-28', '20-31799287-7', NULL, 'CEFERINO', 367, 34);
INSERT INTO persona VALUES ('DNI', 31914692, 'VIDAL', 'ROCIO HILDA', 26, NULL, '1985-10-26', '27-31914692-9', NULL, 'SARGENTO', 238, 21);
INSERT INTO persona VALUES ('DNI', 31963639, 'CARDENAS', 'SANDRA HILDA', 5, NULL, '1985-12-12', '27-31963639-9', NULL, 'TEHUELCHES', 438, 38);
INSERT INTO persona VALUES ('DNI', 31985359, 'PALMA', 'MIRTHA MARIA', 6, NULL, '1986-04-08', '27-31985359-9', NULL, 'AVELLANEDA', 1380, 41);
INSERT INTO persona VALUES ('DNI', 31985648, 'AZOCAR', 'LUCIANA MARIELA', 6, NULL, '1985-12-05', '27-31985648-9', NULL, 'HOSPITAL', 1238, 15);
INSERT INTO persona VALUES ('DNI', 32084930, 'LINARES', 'MIRTHA HAYDEE', 34, NULL, '1986-06-13', '27-32084930-0', NULL, 'REMENTERIA', 1410, 14);
INSERT INTO persona VALUES ('DNI', 32142694, 'VELAZQUEZ', 'ELENA SOFIA', 4, NULL, '1986-03-19', '27-32142694-1', NULL, 'SARGENTO', 715, 14);
INSERT INTO persona VALUES ('DNI', 32169295, 'QUINTEROS', 'MAURO NAHUEL', 21, NULL, '1986-06-19', '20-32169295-1', NULL, 'CUSHAMEN', 1212, 52);
INSERT INTO persona VALUES ('DNI', 32189328, 'VALDEZ', 'NADIA AMALIA', 5, NULL, '1986-01-23', '27-32189328-1', NULL, 'CAMBACERES', 815, 28);
INSERT INTO persona VALUES ('DNI', 32189485, 'BUSTAMANTE', 'LUISA SILVINA', 5, NULL, '1986-04-14', '27-32189485-1', NULL, 'HUMPHREYS', 689, 30);
INSERT INTO persona VALUES ('DNI', 33392717, 'JAMES', 'CAMILA GISELA', 21, NULL, '1988-02-06', '27-33392717-3', NULL, 'TEHUELCHES', 890, 12);
INSERT INTO persona VALUES ('DNI', 32220094, 'GARCIA', 'CAMILA ELIZABETH', 26, NULL, '1986-04-10', '27-32220094-2', NULL, 'WILLIAMS', 733, 44);
INSERT INTO persona VALUES ('DNI', 32233569, 'VARGAS', 'JONATAN NORBERTO', 6, NULL, '1986-06-03', '20-32233569-2', NULL, 'GOLONDRINAS', 179, 13);
INSERT INTO persona VALUES ('DNI', 32388506, 'SANTOS', 'MILAGROS ABRIL', 6, NULL, '1986-03-31', '27-32388506-3', NULL, 'PUEYRREDON', 1455, 55);
INSERT INTO persona VALUES ('DNI', 32429147, 'RIVAS', 'STELLA MARIANELA', 5, NULL, '1986-06-19', '27-32429147-4', NULL, 'CONSTITUYENTES', 372, 53);
INSERT INTO persona VALUES ('DNI', 32538462, 'ZARATE', 'TOMAS JULIO', 26, NULL, '1986-11-03', '20-32538462-5', NULL, 'CORRIENTES', 734, 36);
INSERT INTO persona VALUES ('DNI', 32568674, 'MANSILLA', 'ESTEBAN JONATAN', 21, NULL, '1986-09-25', '20-32568674-5', NULL, 'WILLIAMS', 236, 15);
INSERT INTO persona VALUES ('DNI', 32650030, 'LEIVA', 'MARTIN ALEXIS', 26, NULL, '1986-11-21', '20-32650030-6', NULL, 'INGENIERO', 196, 25);
INSERT INTO persona VALUES ('DNI', 32697667, 'PALACIOS', 'ANGELICA AMALIA', 6, NULL, '1986-12-22', '27-32697667-6', NULL, 'SANTIAGO', 1213, 1);
INSERT INTO persona VALUES ('DNI', 32720290, 'MONTERO', 'MARTA DIANA', 7, NULL, '1987-04-01', '27-32720290-7', NULL, 'MORETEAU', 907, 38);
INSERT INTO persona VALUES ('DNI', 32722000, 'SORIA', 'TAMARA MARIA', 6, NULL, '1987-05-07', '27-32722000-7', NULL, 'VIAMONTE', 248, 2);
INSERT INTO persona VALUES ('DNI', 32748768, 'SORIA', 'LUCIA YANINA', 9, NULL, '1987-01-25', '27-32748768-7', NULL, 'LISANDRO', 1050, 19);
INSERT INTO persona VALUES ('DNI', 32777463, 'JONES', 'FLAVIA FABIANA', 5, NULL, '1986-12-31', '27-32777463-7', NULL, 'AVELLANEDA', 282, 6);
INSERT INTO persona VALUES ('DNI', 32873808, 'MORON', 'GLORIA VICTORIA', 6, NULL, '1987-04-21', '27-32873808-8', NULL, 'INGENIERO', 261, 32);
INSERT INTO persona VALUES ('DNI', 32893019, 'GALVAN', 'LAURA MILAGROS', 34, NULL, '1987-05-21', '27-32893019-8', NULL, 'INDEPENDENCIA', 1378, 15);
INSERT INTO persona VALUES ('DNI', 32923291, 'MARQUEZ', 'GISELA GRISELDA', 6, NULL, '1987-03-04', '27-32923291-9', NULL, 'VILLARINO', 841, 38);
INSERT INTO persona VALUES ('DNI', 32954311, 'GODOY', 'GERARDO JULIAN', 5, NULL, '1987-04-11', '20-32954311-9', NULL, 'CONGRESO', 432, 31);
INSERT INTO persona VALUES ('DNI', 32954340, 'QUILODRAN', 'MAXIMILIANO FABIAN', 5, NULL, '1987-04-01', '20-32954340-9', NULL, 'CORRIENTES', 1125, 3);
INSERT INTO persona VALUES ('DNI', 32954901, 'BRUNT', 'GRACIELA ELENA', 5, NULL, '1987-09-28', '27-32954901-9', NULL, 'PENINSULA', 540, 12);
INSERT INTO persona VALUES ('DNI', 33039280, 'VALLEJOS', 'CINTIA VILMA', 5, NULL, '1987-08-14', '27-33039280-0', NULL, 'CARRENLEUFU', 474, 6);
INSERT INTO persona VALUES ('DNI', 33059038, 'MARQUEZ', 'LIDIA CAROLINA', 26, NULL, '1987-03-31', '27-33059038-0', NULL, 'CONDARCO', 402, 39);
INSERT INTO persona VALUES ('DNI', 33185278, 'ALVARADO', 'CLARA LAURA', 11, NULL, '1988-01-17', '27-33185278-1', NULL, 'CARRENLEUFU', 240, 55);
INSERT INTO persona VALUES ('DNI', 33392529, 'LONCON', 'RAMIRO MAURO', 27, NULL, '1987-08-31', '20-33392529-3', NULL, 'WILLIAMS', 1198, 40);
INSERT INTO persona VALUES ('DNI', 33529182, 'HUGHES', 'NELIDA LILIANA', 21, NULL, '1988-04-05', '27-33529182-5', NULL, 'PORTUGAL', 614, 34);
INSERT INTO persona VALUES ('DNI', 33574918, 'CIFUENTES', 'CATALINA MORENA', 6, NULL, '1989-03-22', '27-33574918-5', NULL, 'YRIGOYEN', 1023, 22);
INSERT INTO persona VALUES ('DNI', 33616875, 'CALVO', 'NORBERTO ELIAS', 30, NULL, '1988-09-09', '20-33616875-6', NULL, 'COLOMBIA', 763, 15);
INSERT INTO persona VALUES ('DNI', 33616890, 'BAHAMONDE', 'LEONARDO ARIEL', 30, NULL, '1988-09-26', '20-33616890-6', NULL, 'INMIGRANTES', 597, 48);
INSERT INTO persona VALUES ('DNI', 33652568, 'VILLARROEL', 'GRACIELA MICAELA', 5, NULL, '1988-05-21', '27-33652568-6', NULL, 'ALMIRANTE', 689, 36);
INSERT INTO persona VALUES ('DNI', 33771513, 'FUENTEALBA', 'SEGUNDO MARIO', 4, NULL, '1988-10-11', '20-33771513-7', NULL, 'PUEYRREDON', 487, 8);
INSERT INTO persona VALUES ('DNI', 33771791, 'ZARATE', 'RAFAEL NORBERTO', 4, NULL, '1989-03-24', '20-33771791-7', NULL, 'LIBERTAD', 1032, 17);
INSERT INTO persona VALUES ('DNI', 33771876, 'BRAVO', 'DAIANA CLAUDIA', 4, NULL, '1989-04-21', '27-33771876-7', NULL, 'AMEGHINO', 859, 7);
INSERT INTO persona VALUES ('DNI', 33772202, 'CALDERON', 'VALENTINA CARMEN', 26, NULL, '1988-07-22', '27-33772202-7', NULL, 'ALMAFUERTE', 515, 53);
INSERT INTO persona VALUES ('DNI', 33775224, 'MEDINA', 'VICTOR CESAR', 23, NULL, '1990-02-10', '20-33775224-7', NULL, 'ANTARTIDA', 667, 31);
INSERT INTO persona VALUES ('DNI', 33793261, 'QUINTANA', 'CARMEN FLORENCIA', 5, NULL, '1989-02-02', '27-33793261-7', NULL, 'ALEJANDRO', 672, 3);
INSERT INTO persona VALUES ('DNI', 33946796, 'RIVAS', 'AGUSTIN MAXIMO', 21, NULL, '1989-08-04', '20-33946796-9', NULL, 'REMENTERIA', 330, 47);
INSERT INTO persona VALUES ('DNI', 33952437, 'PERALTA', 'DIANA SONIA', 6, NULL, '1988-09-27', '27-33952437-9', NULL, 'SANTIAGO', 299, 8);
INSERT INTO persona VALUES ('DNI', 34087350, 'HUENELAF', 'MARCELO CARLOS', 6, NULL, '1988-11-08', '20-34087350-0', NULL, 'LISANDRO', 1215, 18);
INSERT INTO persona VALUES ('DNI', 34144920, 'IBANEZ', 'MELISA LUCIA', 18, NULL, '1989-03-15', '27-34144920-1', NULL, 'MOLINARI', 849, 13);
INSERT INTO persona VALUES ('DNI', 34486653, 'OYARZUN', 'CARLOS RAMIRO', 5, NULL, '1989-04-08', '20-34486653-4', NULL, 'ARENALES', 950, 9);
INSERT INTO persona VALUES ('DNI', 34486688, 'NIETO', 'MARIANA FERNANDA', 5, NULL, '1989-04-13', '27-34486688-4', NULL, 'WILLIAMS', 1143, 56);
INSERT INTO persona VALUES ('DNI', 34488622, 'BRUNT', 'ANDRES ALEXIS', 26, NULL, '1989-04-20', '20-34488622-4', NULL, 'ZORRILLA', 1105, 15);
INSERT INTO persona VALUES ('DNI', 34488624, 'SANTANDER', 'CINTIA NANCY', 26, NULL, '1989-03-12', '27-34488624-4', NULL, 'PARAGUAY', 244, 28);
INSERT INTO persona VALUES ('DNI', 34488766, 'ALBORNOZ', 'SABRINA ABRIL', 21, NULL, '1989-05-12', '27-34488766-4', NULL, 'CONSTITUYENTES', 1284, 3);
INSERT INTO persona VALUES ('DNI', 34488894, 'RAMOS', 'MIRTA MARIELA', 26, NULL, '1989-06-08', '27-34488894-4', NULL, 'TRIUNVIRATO', 1015, 47);
INSERT INTO persona VALUES ('DNI', 34621905, 'BRUNT', 'MAXIMO GABRIEL', 34, NULL, '1989-05-11', '20-34621905-6', NULL, 'CASTELLI', 481, 44);
INSERT INTO persona VALUES ('DNI', 34663788, 'ACOSTA', 'VIVIANA ELVIRA', 4, NULL, '1989-12-22', '27-34663788-6', NULL, 'CORRIENTES', 302, 41);
INSERT INTO persona VALUES ('DNI', 34664242, 'LINARES', 'BRENDA LUCIANA', 5, NULL, '1989-08-30', '27-34664242-6', NULL, 'MALVINAS', 204, 19);
INSERT INTO persona VALUES ('DNI', 34667682, 'SANTOS', 'SANTIAGO HECTOR', 29, NULL, '1989-06-14', '20-34667682-6', NULL, 'GRANADEROS', 1334, 47);
INSERT INTO persona VALUES ('DNI', 34726897, 'MONTENEGRO', 'MICAELA SANDRA', 36, NULL, '1990-08-20', '27-34726897-7', NULL, 'SARGENTO', 1401, 53);
INSERT INTO persona VALUES ('DNI', 34784310, 'NIETO', 'ELIANA MIRIAM', 1, NULL, '1989-10-07', '27-34784310-7', NULL, 'GUILLERMO', 1493, 25);
INSERT INTO persona VALUES ('DNI', 34868669, 'BUSTAMANTE', 'OSCAR DANIEL', 4, NULL, '1990-01-11', '20-34868669-8', NULL, 'MOLINARI', 1051, 26);
INSERT INTO persona VALUES ('DNI', 34967321, 'IBARRA', 'FRANCISCO ROBERTO', 33, NULL, '1989-11-24', '20-34967321-9', NULL, 'TENIENTE', 961, 49);
INSERT INTO persona VALUES ('DNI', 35002167, 'ZALAZAR', 'EDGARDO RUBEN', 17, NULL, '1990-08-26', '20-35002167-0', NULL, 'OLAVARRIA', 318, 6);
INSERT INTO persona VALUES ('DNI', 35030083, 'ROSALES', 'MAURO RAMON', 5, NULL, '1989-12-15', '20-35030083-0', NULL, 'HIPOLITO', 1487, 27);
INSERT INTO persona VALUES ('DNI', 35047205, 'WILLIAMS', 'FERNANDO MATIAS', 6, NULL, '1989-09-30', '20-35047205-0', NULL, 'PENINSULA', 113, 23);
INSERT INTO persona VALUES ('DNI', 35047249, 'GUERRERO', 'FABIAN ALEXIS', 6, NULL, '1989-10-02', '20-35047249-0', NULL, 'AVELLANEDA', 797, 28);
INSERT INTO persona VALUES ('DNI', 35171950, 'FERREYRA', 'JORGE NORBERTO', 6, NULL, '1990-05-17', '20-35171950-1', NULL, 'ALMAFUERTE', 1440, 42);
INSERT INTO persona VALUES ('DNI', 35172890, 'NUNEZ', 'NATALIA MARCELA', 8, NULL, '1990-06-06', '27-35172890-1', NULL, 'RECONQUISTA', 1381, 12);
INSERT INTO persona VALUES ('DNI', 33280222, 'JONES', 'SANTIAGO LEONARDO', 29, NULL, '1987-06-07', '20-33280222-2', NULL, 'RIVADAVIA', 96, 5);
INSERT INTO persona VALUES ('DNI', 33315592, 'VILLEGAS', 'ROMINA SOFIA', 5, NULL, '1987-11-17', '27-33315592-3', NULL, 'SAAVEDRA', 554, 50);
INSERT INTO persona VALUES ('DNI', 33316018, 'MARTIN', 'RUBEN ADRIAN', 6, NULL, '1987-06-28', '20-33316018-3', NULL, 'CHACABUCO', 78, 30);
INSERT INTO persona VALUES ('DNI', 33316071, 'GONZALEZ', 'FERNANDO MATIAS', 35, NULL, '1987-07-10', '20-33316071-3', NULL, 'GOBERNADOR', 1204, 12);
INSERT INTO persona VALUES ('DNI', 33323237, 'DAVIES', 'MAXIMO CRISTIAN', 15, NULL, '1988-02-25', '20-33323237-3', NULL, 'WILLIAMS', 464, 44);
INSERT INTO persona VALUES ('DNI', 33345183, 'ALTAMIRANO', 'CAROLINA LETICIA', 26, NULL, '1987-10-28', '27-33345183-3', NULL, 'ALMAFUERTE', 1142, 1);
INSERT INTO persona VALUES ('DNI', 33345365, 'URIBE', 'MACARENA PAOLA', 26, NULL, '1987-12-11', '27-33345365-3', NULL, 'PENINSULA', 781, 15);
INSERT INTO persona VALUES ('DNI', 33355138, 'NAHUELQUIR', 'SABRINA JULIA', 5, NULL, '1988-01-09', '27-33355138-3', NULL, 'ALEJANDRO', 166, 32);
INSERT INTO persona VALUES ('DNI', 33392509, 'ALMONACID', 'MELINA ABRIL', 21, NULL, '1987-10-02', '27-33392509-3', NULL, 'TRIUNVIRATO', 925, 9);
INSERT INTO persona VALUES ('DNI', 35176552, 'MANRIQUE', 'MAIRA PATRICIA', 15, NULL, '1990-01-22', '27-35176552-1', NULL, 'CASTELLI', 1190, 32);
INSERT INTO persona VALUES ('DNI', 35218837, 'PAREDES', 'CARLOS RUBEN', 5, NULL, '1990-07-11', '20-35218837-2', NULL, 'PIETROBELLI', 875, 45);
INSERT INTO persona VALUES ('DNI', 35381326, 'PARRA', 'MARIANA DAIANA', 7, NULL, '1990-06-29', '27-35381326-3', NULL, 'TEHUELCHES', 837, 18);
INSERT INTO persona VALUES ('DNI', 35381482, 'GOMEZ', 'MELISA LUISA', 4, NULL, '1990-09-13', '27-35381482-3', NULL, 'ESCALADA', 1395, 29);
INSERT INTO persona VALUES ('DNI', 35382451, 'GEREZ', 'OSVALDO ROBERTO', 5, NULL, '1990-12-12', '20-35382451-3', NULL, 'CALAFATE', 1479, 1);
INSERT INTO persona VALUES ('DNI', 35383105, 'TORRES', 'CAROLINA ADRIANA', 6, NULL, '1990-07-02', '27-35383105-3', NULL, 'PIEDRABUENA', 856, 47);
INSERT INTO persona VALUES ('DNI', 35659009, 'GARCIA', 'IVANA PATRICIA', 6, NULL, '1991-01-11', '27-35659009-6', NULL, 'ALMAFUERTE', 1193, 32);
INSERT INTO persona VALUES ('DNI', 35659086, 'POBLETE', 'ALEJANDRO CESAR', 6, NULL, '1990-12-20', '20-35659086-6', NULL, 'HIPOLITO', 538, 48);
INSERT INTO persona VALUES ('DNI', 35886876, 'SILVA', 'NILDA ELIDA', 22, NULL, '1994-07-27', '27-35886876-8', NULL, 'TENIENTE', 1357, 31);
INSERT INTO persona VALUES ('DNI', 35888484, 'OVIEDO', 'RAQUEL STELLA', 5, NULL, '1991-09-07', '27-35888484-8', NULL, 'FOURNIER', 432, 15);
INSERT INTO persona VALUES ('DNI', 35889336, 'VILLALBA', 'ROSANA CARINA', 6, NULL, '1991-08-12', '27-35889336-8', NULL, 'ANTARTIDA', 268, 8);
INSERT INTO persona VALUES ('DNI', 35889531, 'LAGOS', 'EDITH MILAGROS', 7, NULL, '1991-06-26', '27-35889531-8', NULL, 'CANGALLO', 853, 19);
INSERT INTO persona VALUES ('DNI', 35889600, 'CATALAN', 'FABIANA LORENA', 7, NULL, '1992-01-30', '27-35889600-8', NULL, 'PIETROBELLI', 349, 9);
INSERT INTO persona VALUES ('DNI', 35889868, 'HEREDIA', 'ANDRES FELIX', 30, NULL, '1991-03-16', '20-35889868-8', NULL, 'COLOMBIA', 709, 34);
INSERT INTO persona VALUES ('DNI', 35928690, 'PRIETO', 'SILVINA NILDA', 6, NULL, '1990-11-20', '27-35928690-9', NULL, 'TUPUNGATO', 1409, 45);
INSERT INTO persona VALUES ('DNI', 36106160, 'CRESPO', 'FLORENCIA MIRTA', 28, NULL, '1990-11-12', '27-36106160-1', NULL, 'AMEGHINO', 1042, 57);
INSERT INTO persona VALUES ('DNI', 36181720, 'IGLESIAS', 'GLADIS ERICA', 18, NULL, '1991-10-30', '27-36181720-1', NULL, 'ARISTOBULO', 1147, 40);
INSERT INTO persona VALUES ('DNI', 36212878, 'SORIA', 'BRIAN RUBEN', 4, NULL, '1991-05-08', '20-36212878-2', NULL, 'VILLEGAS', 198, 13);
INSERT INTO persona VALUES ('DNI', 36647874, 'CIFUENTES', 'JONATHAN VICTOR', 6, NULL, '1993-03-18', '20-36647874-6', NULL, 'OLAVARRIA', 1038, 22);
INSERT INTO persona VALUES ('DNI', 36718873, 'EVANS', 'MARIO EMILIO', 6, NULL, '1992-03-28', '20-36718873-7', NULL, 'COLOMBIA', 1102, 9);
INSERT INTO persona VALUES ('DNI', 36719465, 'GUZMAN', 'ALDANA IRENE', 6, NULL, '1992-09-08', '27-36719465-7', NULL, 'HIPOLITO', 1274, 55);
INSERT INTO persona VALUES ('DNI', 36791907, 'PARADA', 'DEBORA MARTINA', 36, NULL, '1992-03-07', '27-36791907-7', NULL, 'QUINTANA', 1423, 34);
INSERT INTO persona VALUES ('DNI', 37006500, 'RUBILAR', 'OSCAR CLAUDIO', 5, NULL, '1992-09-03', '20-37006500-0', NULL, 'INGENIERO', 826, 14);
INSERT INTO persona VALUES ('DNI', 37067840, 'AVILES', 'LAURA MONICA', 26, NULL, '1992-08-28', '27-37067840-0', NULL, 'CORRIENTES', 189, 46);
INSERT INTO persona VALUES ('DNI', 37068029, 'GIMENEZ', 'KAREN RAQUEL', 6, NULL, '1992-09-20', '27-37068029-0', NULL, 'NECOCHEA', 582, 5);
INSERT INTO persona VALUES ('DNI', 37068721, 'SALAZAR', 'LUCIANA CARMEN', 6, NULL, '1994-07-13', '27-37068721-0', NULL, 'AZOPARDO', 70, 26);
INSERT INTO persona VALUES ('DNI', 37069026, 'JARAMILLO', 'VICTORIA CANDELA', 16, NULL, '1992-11-29', '27-37069026-0', NULL, 'TENIENTE', 1466, 31);
INSERT INTO persona VALUES ('DNI', 37147923, 'FRANCO', 'LUCIANA GLORIA', 21, NULL, '1993-09-27', '27-37147923-1', NULL, 'MISIONES', 1009, 6);
INSERT INTO persona VALUES ('DNI', 37147949, 'PERALTA', 'YAMILA LORENA', 21, NULL, '1993-10-22', '27-37147949-1', NULL, 'SARMIENTO', 1293, 40);
INSERT INTO persona VALUES ('DNI', 37147984, 'SALDIVIA', 'CESAR HERNAN', 21, NULL, '1993-11-11', '20-37147984-1', NULL, 'ALBARRACIN', 951, 4);
INSERT INTO persona VALUES ('DNI', 37148086, 'RAMOS', 'NORBERTO LUCAS', 3, NULL, '1993-12-13', '20-37148086-1', NULL, 'HONDURAS', 224, 15);
INSERT INTO persona VALUES ('DNI', 37149129, 'ZUNIGA', 'NORBERTO LUCIANO', 26, NULL, '1992-11-22', '20-37149129-1', NULL, 'PENINSULA', 1089, 14);
INSERT INTO persona VALUES ('DNI', 37149146, 'OJEDA', 'MARTIN EMANUEL', 26, NULL, '1992-11-10', '20-37149146-1', NULL, 'CAMBACERES', 1234, 48);
INSERT INTO persona VALUES ('DNI', 37149531, 'SANDOVAL', 'HILDA VICTORIA', 6, NULL, '1993-03-10', '27-37149531-1', NULL, 'ANTARTIDA', 646, 33);
INSERT INTO persona VALUES ('DNI', 37149573, 'AVILA', 'SANTIAGO FEDERICO', 6, NULL, '1993-03-21', '20-37149573-1', NULL, 'MISIONES', 222, 43);
INSERT INTO persona VALUES ('DNI', 37149762, 'TRONCOSO', 'NELSON GUILLERMO', 6, NULL, '1993-05-07', '20-37149762-1', NULL, 'ZORRILLA', 1489, 49);
INSERT INTO persona VALUES ('DNI', 37151708, 'PACHECO', 'CAROLINA HILDA', 2, NULL, '1993-05-14', '27-37151708-1', NULL, 'FEDERICCI', 1375, 21);
INSERT INTO persona VALUES ('DNI', 37154408, 'AZOCAR', 'MARCOS KEVIN', 37, NULL, '1991-03-28', '20-37154408-1', NULL, 'GUALJAINA', 754, 16);
INSERT INTO persona VALUES ('DNI', 37347319, 'MARTIN', 'JULIA VIVIANA', 4, NULL, '1993-07-29', '27-37347319-3', NULL, 'OLAVARRIA', 1459, 38);
INSERT INTO persona VALUES ('DNI', 37347611, 'RIVERA', 'CATALINA MARIELA', 30, NULL, '1993-10-13', '27-37347611-3', NULL, 'HIPOLITO', 152, 52);
INSERT INTO persona VALUES ('DNI', 37347866, 'MARQUEZ', 'LETICIA ISABEL', 5, NULL, '1994-09-21', '27-37347866-3', NULL, 'PENINSULA', 215, 31);
INSERT INTO persona VALUES ('DNI', 37550801, 'ACOSTA', 'MARISA FLAVIA', 21, NULL, '1993-07-02', '27-37550801-5', NULL, 'SARGENTO', 873, 47);
INSERT INTO persona VALUES ('DNI', 37641321, 'ORELLANA', 'NADIA CECILIA', 5, NULL, '1994-09-27', '27-37641321-6', NULL, 'TUPUNGATO', 729, 12);
INSERT INTO persona VALUES ('DNI', 37665309, 'LONCON', 'MARIANA AGUSTINA', 6, NULL, '1993-10-29', '27-37665309-6', NULL, 'AYACUCHO', 1421, 40);
INSERT INTO persona VALUES ('DNI', 37665374, 'MANRIQUEZ', 'EZEQUIEL RICARDO', 6, NULL, '1993-11-14', '20-37665374-6', NULL, 'ANTARTIDA', 186, 21);
INSERT INTO persona VALUES ('DNI', 37666304, 'VARGAS', 'VALENTINA YOLANDA', 5, NULL, '1993-09-21', '27-37666304-6', NULL, 'RIFLEROS', 121, 57);
INSERT INTO persona VALUES ('DNI', 37676641, 'CRESPO', 'SILVINA JULIETA', 10, NULL, '1994-02-09', '27-37676641-6', NULL, 'ALMAFUERTE', 1041, 38);
INSERT INTO persona VALUES ('DNI', 37676667, 'NAHUELQUIR', 'EDGARDO VICTOR', 5, NULL, '1994-03-23', '20-37676667-6', NULL, 'LIBERTAD', 924, 2);
INSERT INTO persona VALUES ('DNI', 37676847, 'AVENDANO', 'RICARDO CLAUDIO', 5, NULL, '1994-07-08', '20-37676847-6', NULL, 'INDEPENDENCIA', 702, 11);
INSERT INTO persona VALUES ('DNI', 37676898, 'EVANS', 'JOAQUIN MIGUEL', 5, NULL, '1994-07-16', '20-37676898-6', NULL, 'PECORARO', 1100, 1);
INSERT INTO persona VALUES ('DNI', 37764671, 'OVIEDO', 'HILDA MARTHA', 6, NULL, '1994-02-04', '27-37764671-7', NULL, 'MALASPINA', 225, 11);
INSERT INTO persona VALUES ('DNI', 37764772, 'PARADA', 'GLADIS LUCIANA', 6, NULL, '1993-11-22', '27-37764772-7', NULL, 'NAHUELPAN', 672, 7);
INSERT INTO persona VALUES ('DNI', 37860610, 'ALMONACID', 'CARLA NOEMI', 26, NULL, '1993-12-23', '27-37860610-8', NULL, 'SAAVEDRA', 954, 35);
INSERT INTO persona VALUES ('DNI', 37860666, 'CALDERON', 'ALEJANDRA NILDA', 26, NULL, '1993-11-25', '27-37860666-8', NULL, 'CALAFATE', 1034, 24);
INSERT INTO persona VALUES ('DNI', 37909364, 'ACOSTA', 'MARINA KAREN', 26, NULL, '1993-09-17', '27-37909364-9', NULL, 'CENTENARIO', 1098, 54);
INSERT INTO persona VALUES ('DNI', 37988265, 'EVANS', 'NESTOR GASTON', 36, NULL, '1995-03-06', '20-37988265-9', NULL, 'SARMIENTO', 468, 39);
INSERT INTO persona VALUES ('DNI', 38046207, 'ROCHA', 'ANALIA IVANA', 21, NULL, '1994-03-16', '27-38046207-0', NULL, 'ZORRILLA', 985, 50);
INSERT INTO persona VALUES ('DNI', 38046260, 'HERNANDEZ', 'AMELIA VILMA', 21, NULL, '1994-05-06', '27-38046260-0', NULL, 'MOLINARI', 160, 26);
INSERT INTO persona VALUES ('DNI', 38046492, 'NEIRA', 'NICOLAS DANIEL', 21, NULL, '1994-09-26', '20-38046492-0', NULL, 'GUILLERMO', 165, 45);
INSERT INTO persona VALUES ('DNI', 38080933, 'ARIAS', 'MERCEDES LIDIA', 9, NULL, '1994-07-24', '27-38080933-0', NULL, 'TENIENTE', 40, 32);
INSERT INTO persona VALUES ('DNI', 38147591, 'ROSAS', 'MAXIMO EMANUEL', 26, NULL, '1994-05-11', '20-38147591-1', NULL, 'HIPOLITO', 453, 30);
INSERT INTO persona VALUES ('DNI', 38232383, 'SANTANA', 'VIVIANA DEBORA', 5, NULL, '1993-02-19', '27-38232383-2', NULL, 'PUEYRREDON', 845, 1);
INSERT INTO persona VALUES ('DNI', 36320922, 'GALLARDO', 'MELINA NANCY', 14, NULL, '1992-02-20', '27-36320922-3', NULL, 'COMERCIO', 1394, 45);
INSERT INTO persona VALUES ('DNI', 36320931, 'MANRIQUEZ', 'TERESA MARGARITA', 4, NULL, '1991-11-13', '27-36320931-3', NULL, 'SARGENTO', 1323, 19);
INSERT INTO persona VALUES ('DNI', 36321774, 'ACEVEDO', 'RAFAEL MIGUEL', 5, NULL, '1992-09-07', '20-36321774-3', NULL, 'DIAGONAL', 336, 34);
INSERT INTO persona VALUES ('DNI', 36321864, 'GRIFFITHS', 'DAIANA CLARA', 5, NULL, '1992-10-25', '27-36321864-3', NULL, 'HOSPITAL', 1104, 29);
INSERT INTO persona VALUES ('DNI', 36322082, 'QUINTANA', 'HECTOR DAMIAN', 24, NULL, '1992-08-20', '20-36322082-3', NULL, 'HUMPHREYS', 923, 9);
INSERT INTO persona VALUES ('DNI', 36322225, 'ROSSI', 'YANINA DAIANA', 32, NULL, '1994-04-24', '27-36322225-3', NULL, 'O''HIGGINS', 1028, 55);
INSERT INTO persona VALUES ('DNI', 36334179, 'OLIVA', 'VICTORIA LUISA', 6, NULL, '1992-05-11', '27-36334179-3', NULL, 'FEDERICCI', 1163, 45);
INSERT INTO persona VALUES ('DNI', 31148538, 'ZALAZAR', 'CARMEN VILMA', 26, NULL, '1985-01-10', '27-31148538-1', NULL, 'RECONQUISTA', 438, 47);
INSERT INTO persona VALUES ('DNI', 31148849, 'DELGADO', 'JUANA CAROLINA', 13, NULL, '1985-03-28', '27-31148849-1', NULL, 'OLAVARRIA', 166, 48);
INSERT INTO persona VALUES ('DNI', 31211783, 'CORONADO', 'AMALIA MAIRA', 35, NULL, '1984-12-07', '27-31211783-2', NULL, 'HONDURAS', 1052, 17);
INSERT INTO persona VALUES ('DNI', 31243077, 'OJEDA', 'JOAQUIN ESTEBAN', 21, NULL, '1984-01-31', '20-31243077-2', NULL, 'COMODORO', 568, 35);
INSERT INTO persona VALUES ('DNI', 31350868, 'SAAVEDRA', 'LAUTARO WALTER', 6, NULL, '1985-05-13', '20-31350868-3', NULL, 'COMISARIA', 601, 1);
INSERT INTO persona VALUES ('DNI', 36393277, 'CAMPOS', 'AGOSTINA VANESA', 30, NULL, '1991-07-27', '27-36393277-3', NULL, 'PIEDRABUENA', 122, 57);
INSERT INTO persona VALUES ('DNI', 36393283, 'EVANS', 'GRACIELA ELIANA', 30, NULL, '1991-10-08', '27-36393283-3', NULL, 'INGENIERO', 739, 56);
INSERT INTO persona VALUES ('DNI', 36494625, 'CALDERON', 'MIRIAM LORENA', 6, NULL, '1992-03-03', '27-36494625-4', NULL, 'PIEDRABUENA', 1475, 58);
INSERT INTO persona VALUES ('DNI', 36580201, 'GUTIERREZ', 'RAMON JOAQUIN', 12, NULL, '1991-10-17', '20-36580201-5', NULL, 'RIVADAVIA', 622, 36);
INSERT INTO persona VALUES ('DNI', 38300437, 'ROSAS', 'YOLANDA GUADALUPE', 26, NULL, '1994-09-22', '27-38300437-3', NULL, 'RIFLEROS', 377, 58);
INSERT INTO persona VALUES ('DNI', 38443349, 'OLIVA', 'VICENTE PABLO', 35, NULL, '1994-07-19', '20-38443349-4', NULL, 'INMIGRANTES', 1261, 10);
INSERT INTO persona VALUES ('DNI', 38535811, 'SUAREZ', 'HILDA ESTELA', 6, NULL, '1994-11-08', '27-38535811-5', NULL, 'CONGRESO', 1235, 37);
INSERT INTO persona VALUES ('DNI', 38535815, 'ORTIZ', 'SABRINA MARINA', 4, NULL, '1994-11-05', '27-38535815-5', NULL, 'PENINSULA', 47, 9);
INSERT INTO persona VALUES ('DNI', 38711051, 'VELAZQUEZ', 'JONATHAN CLAUDIO', 5, NULL, '1995-02-14', '20-38711051-7', NULL, 'LIBERTAD', 1488, 18);
INSERT INTO persona VALUES ('DNI', 38784419, 'NUNEZ', 'BRIAN CRISTIAN', 26, NULL, '1994-12-24', '20-38784419-7', NULL, 'CASTELLI', 220, 12);
INSERT INTO persona VALUES ('DNI', 38784484, 'RIVERA', 'EZEQUIEL BRUNO', 26, NULL, '1995-02-17', '20-38784484-7', NULL, 'TENIENTE', 1344, 34);
INSERT INTO persona VALUES ('DNI', 38784653, 'CARDENAS', 'GABRIELA MARISA', 26, NULL, '1995-04-10', '27-38784653-7', NULL, 'CORCOVADO', 788, 12);
INSERT INTO persona VALUES ('DNI', 38799829, 'AVILA', 'MIRIAM ELISA', 25, NULL, '1995-03-15', '27-38799829-7', NULL, 'SOBERANIA', 1207, 52);
INSERT INTO persona VALUES ('DNI', 38801908, 'SALINAS', 'LEANDRO ADRIAN', 6, NULL, '1995-05-29', '20-38801908-8', NULL, 'CALLEJON', 257, 25);
INSERT INTO persona VALUES ('DNI', 38803935, 'ZALAZAR', 'LAURA ALEJANDRA', 26, NULL, '1995-04-03', '27-38803935-8', NULL, 'AYACUCHO', 1225, 38);
INSERT INTO persona VALUES ('DNI', 38806179, 'LUCERO', 'VICTOR ARIEL', 21, NULL, '1991-04-27', '20-38806179-8', NULL, 'ARENALES', 834, 38);
INSERT INTO persona VALUES ('DNI', 39059353, 'GALLEGOS', 'SILVINA JULIA', 6, NULL, '1995-05-17', '27-39059353-0', NULL, 'HIPOLITO', 1200, 57);
INSERT INTO persona VALUES ('DNI', 23099369, 'MONTENEGRO', 'JULIA MARIELA', 26, NULL, '1960-02-16', '27-23099369-0', NULL, 'FEDERICCI', 1326, 9);
INSERT INTO persona VALUES ('DNI', 23172838, 'VELASQUEZ', 'MARIELA ANGELICA', 26, NULL, '1960-05-24', '27-23172838-1', NULL, 'ANTARTIDA', 1098, 39);
INSERT INTO persona VALUES ('DNI', 23172855, 'QUINTEROS', 'ADRIAN JESUS', 26, NULL, '1960-05-29', '20-23172855-1', NULL, 'GOBERNADOR', 564, 43);
INSERT INTO persona VALUES ('DNI', 23547074, 'ROMERO', 'MARISA NATALIA', 26, NULL, '1961-06-04', '27-23547074-5', NULL, 'CONSTITUYENTES', 109, 28);
INSERT INTO persona VALUES ('DNI', 23569160, 'CABRERA', 'GLADYS EDITH', 26, NULL, '1961-01-26', '27-23569160-5', NULL, 'NAHUELPAN', 848, 14);
INSERT INTO persona VALUES ('DNI', 23712808, 'BARRIOS', 'ANDREA FABIANA', 26, NULL, '1960-05-16', '27-23712808-7', NULL, 'FLORENCIO', 94, 13);
INSERT INTO persona VALUES ('DNI', 23774554, 'REINOSO', 'LAUTARO EMANUEL', 21, NULL, '1961-03-22', '20-23774554-7', NULL, 'HIPOLITO', 224, 37);
INSERT INTO persona VALUES ('DNI', 23887357, 'JONES', 'ROCIO ANGELA', 21, NULL, '1961-10-24', '27-23887357-8', NULL, 'PECORARO', 208, 9);
INSERT INTO persona VALUES ('DNI', 16460835, 'CIFUENTES', 'ABRIL JULIETA', 34, NULL, '1990-10-03', '27-16460835-4', NULL, 'REMENTERIA', 1418, 58);
INSERT INTO persona VALUES ('DNI', 29836430, 'BRAVO', 'PAMELA CELIA', 26, NULL, '1983-06-13', '27-29836430-8', NULL, 'SARMIENTO', 689, 25);
INSERT INTO persona VALUES ('DNI', 29957251, 'ACUNA', 'GONZALO FABIAN', 6, NULL, '1983-07-22', '20-29957251-9', NULL, 'MISIONES', 192, 57);
INSERT INTO persona VALUES ('DNI', 29984297, 'BLANCO', 'ELIANA AMALIA', 16, NULL, '1983-07-26', '27-29984297-9', NULL, 'PUEYRREDON', 310, 16);
INSERT INTO persona VALUES ('DNI', 30063150, 'PEREIRA', 'NAHUEL CRISTIAN', 31, NULL, '1983-09-30', '20-30063150-0', NULL, 'VILLEGAS', 1460, 58);
INSERT INTO persona VALUES ('DNI', 30505921, 'BARROSO', 'MELISA PAMELA', 6, NULL, '1983-11-10', '27-30505921-5', NULL, 'COMODORO', 888, 14);
INSERT INTO persona VALUES ('DNI', 30517538, 'GALLEGOS', 'ROMINA BRENDA', 26, NULL, '1983-11-12', '27-30517538-5', NULL, 'NICARAGUA', 193, 56);
INSERT INTO persona VALUES ('DNI', 30519907, 'RODRIGUEZ', 'VICTORIA MARCELA', 4, NULL, '1983-09-13', '27-30519907-5', NULL, 'CONGRESO', 457, 57);
INSERT INTO persona VALUES ('DNI', 30550115, 'VALLEJOS', 'SERGIO RODRIGO', 4, NULL, '1983-10-23', '20-30550115-5', NULL, 'ANTARTIDA', 984, 50);
INSERT INTO persona VALUES ('DNI', 30550175, 'CABRERA', 'MARISA TERESA', 4, NULL, '1983-10-29', '27-30550175-5', NULL, 'MALASPINA', 192, 55);
INSERT INTO persona VALUES ('DNI', 30550240, 'AGUERO', 'CYNTHIA TAMARA', 35, NULL, '1983-12-20', '27-30550240-5', NULL, 'FLORENCIO', 785, 8);
INSERT INTO persona VALUES ('DNI', 30550811, 'QUILODRAN', 'RICARDO MIGUEL', 24, NULL, '1984-01-18', '20-30550811-5', NULL, 'CALLEJON', 14, 27);
INSERT INTO persona VALUES ('DNI', 30550812, 'ORELLANA', 'CARINA MACARENA', 34, NULL, '1983-12-09', '27-30550812-5', NULL, 'ESCALADA', 748, 5);
INSERT INTO persona VALUES ('DNI', 30578189, 'MOLINA', 'ELISA IVANA', 4, NULL, '1984-10-18', '27-30578189-5', NULL, 'YRIGOYEN', 955, 26);
INSERT INTO persona VALUES ('DNI', 30580269, 'HUGHES', 'LETICIA CELIA', 21, NULL, '1984-05-09', '27-30580269-5', NULL, 'FOURNIER', 235, 40);
INSERT INTO persona VALUES ('DNI', 30801436, 'ROBERTS', 'MARIELA MARIANA', 6, NULL, '1985-06-21', '27-30801436-8', NULL, 'TUPUNGATO', 55, 39);
INSERT INTO persona VALUES ('DNI', 30806005, 'DOMINGUEZ', 'ANDRES MAURICIO', 5, NULL, '1984-04-23', '20-30806005-8', NULL, 'MORETEAU', 1320, 38);
INSERT INTO persona VALUES ('DNI', 30811435, 'LOPEZ', 'SUSANA VICTORIA', 4, NULL, '1984-02-09', '27-30811435-8', NULL, 'REMEDIOS', 88, 32);
INSERT INTO persona VALUES ('DNI', 30853757, 'CERDA', 'TOMAS DAVID', 19, NULL, '1984-05-22', '20-30853757-8', NULL, 'LAGUNITA', 896, 5);
INSERT INTO persona VALUES ('DNI', 30859030, 'ARANDA', 'ELIDA JULIETA', 16, NULL, '1984-08-15', '27-30859030-8', NULL, 'COLOMBIA', 145, 17);
INSERT INTO persona VALUES ('DNI', 30883617, 'GARCIA', 'JEREMIAS LUCAS', 20, NULL, '1984-03-27', '20-30883617-8', NULL, 'GOBERNADOR', 997, 11);
INSERT INTO persona VALUES ('DNI', 30883736, 'VARELA', 'MATIAS MAURICIO', 26, NULL, '1984-04-21', '20-30883736-8', NULL, 'LIBERTAD', 294, 3);
INSERT INTO persona VALUES ('DNI', 30936707, 'GARCIA', 'AMELIA LUISA', 6, NULL, '1984-11-12', '27-30936707-9', NULL, 'INMIGRANTES', 1135, 26);
INSERT INTO persona VALUES ('DNI', 30936882, 'NIETO', 'JULIAN WALTER', 6, NULL, '1984-12-24', '20-30936882-9', NULL, 'INMIGRANTES', 1383, 50);
INSERT INTO persona VALUES ('DNI', 30965345, 'ORTEGA', 'SERGIO GUILLERMO', 21, NULL, '1984-07-20', '20-30965345-9', NULL, 'QUINTANA', 1054, 46);
INSERT INTO persona VALUES ('DNI', 30976180, 'GRIFFITHS', 'GUSTAVO RODRIGO', 5, NULL, '1984-05-21', '20-30976180-9', NULL, 'HUMPHREYS', 608, 54);
INSERT INTO persona VALUES ('DNI', 30976361, 'YANEZ', 'GERMAN MAURO', 5, NULL, '1984-08-23', '20-30976361-9', NULL, 'INMIGRANTES', 601, 5);
INSERT INTO persona VALUES ('DNI', 31117929, 'MARIN', 'VILMA MICAELA', 4, NULL, '1984-12-07', '27-31117929-1', NULL, 'LISANDRO', 90, 58);
INSERT INTO persona VALUES ('DNI', 31123263, 'OYARZUN', 'MARTA CECILIA', 30, NULL, '1984-12-11', '27-31123263-1', NULL, 'ESCALADA', 1367, 31);
INSERT INTO persona VALUES ('DNI', 23887499, 'YANEZ', 'TOMAS ALEJANDRO', 21, NULL, '1962-02-03', '20-23887499-8', NULL, 'DIAGONAL', 674, 14);
INSERT INTO persona VALUES ('DNI', 23887854, 'ZARATE', 'SANTIAGO LEONARDO', 26, NULL, '1961-02-19', '20-23887854-8', NULL, 'YRIGOYEN', 1011, 57);
INSERT INTO persona VALUES ('DNI', 24212891, 'HERNANDEZ', 'DELIA JOHANA', 26, NULL, '1961-06-09', '27-24212891-2', NULL, 'CENTENARIO', 919, 56);
INSERT INTO persona VALUES ('DNI', 24637839, 'TRONCOSO', 'FABIANA CARINA', 26, NULL, '1962-03-06', '27-24637839-6', NULL, 'FEDERICCI', 132, 12);
INSERT INTO persona VALUES ('DNI', 24650524, 'DAVIES', 'EMANUEL MAURICIO', 26, NULL, '1961-12-04', '20-24650524-6', NULL, 'COMODORO', 180, 15);
INSERT INTO persona VALUES ('DNI', 24650575, 'GONZALEZ', 'RAFAEL EMILIANO', 26, NULL, '1962-01-08', '20-24650575-6', NULL, 'CEFERINO', 1325, 56);
INSERT INTO persona VALUES ('DNI', 24650693, 'GOMEZ', 'ROXANA LUCIANA', 26, NULL, '1962-01-11', '27-24650693-6', NULL, 'GOLONDRINAS', 1418, 11);
INSERT INTO persona VALUES ('DNI', 24650865, 'SANTOS', 'SILVIA MARIANELA', 26, NULL, '1962-03-18', '27-24650865-6', NULL, 'ESCALADA', 675, 29);
INSERT INTO persona VALUES ('DNI', 24650982, 'ALVAREZ', 'SILVIA CARLA', 26, NULL, '1962-04-20', '27-24650982-6', NULL, 'FRANCISCO', 858, 54);
INSERT INTO persona VALUES ('DNI', 24757164, 'BARRERA', 'DELIA VANESA', 21, NULL, '1962-06-08', '27-24757164-7', NULL, 'CENTENARIO', 1458, 9);
INSERT INTO persona VALUES ('DNI', 24757243, 'CASANOVA', 'EZEQUIEL DOMINGO', 21, NULL, '1962-07-14', '20-24757243-7', NULL, 'CONGRESO', 972, 20);
INSERT INTO persona VALUES ('DNI', 24757264, 'CASTRO', 'MONICA CAROLINA', 21, NULL, '1962-08-03', '27-24757264-7', NULL, 'HONDURAS', 907, 50);
INSERT INTO persona VALUES ('DNI', 24757407, 'ALTAMIRANO', 'IVANA LORENA', 21, NULL, '1962-10-27', '27-24757407-7', NULL, 'AZOPARDO', 1106, 17);
INSERT INTO persona VALUES ('DNI', 24757409, 'FERREYRA', 'HILDA MABEL', 21, NULL, '1962-10-30', '27-24757409-7', NULL, 'PATAGONIA', 214, 47);
INSERT INTO persona VALUES ('DNI', 30008678, 'SUAREZ', 'CINTIA ANDREA', 6, NULL, '1983-12-01', '27-30008678-0', NULL, 'VILLEGAS', 303, 12);


--
-- Name: pk_administrativo; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY administrativo
    ADD CONSTRAINT pk_administrativo PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_alumno; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY alumno
    ADD CONSTRAINT pk_alumno PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_alumno_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY alumno_curso
    ADD CONSTRAINT pk_alumno_curso PRIMARY KEY (tipo_documento, numero_documento, anio, division, ciclo_lectivo);


--
-- Name: pk_asistencia; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT pk_asistencia PRIMARY KEY (tipo_documento, numero_documento, anio, division, ciclo_lectivo, materia, fecha);


--
-- Name: pk_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT pk_curso PRIMARY KEY (anio, division, ciclo_lectivo);


--
-- Name: pk_docente; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY docente
    ADD CONSTRAINT pk_docente PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: pk_docente_curso; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT pk_docente_curso PRIMARY KEY (anio, division, ciclo_lectivo, materia);


--
-- Name: pk_examen; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT pk_examen PRIMARY KEY (id);


--
-- Name: pk_examen_alumno; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT pk_examen_alumno PRIMARY KEY (tipo_doc_alumno, numero_doc_alumno, examen);


--
-- Name: pk_localidad; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY localidad
    ADD CONSTRAINT pk_localidad PRIMARY KEY (codigo);


--
-- Name: pk_materia; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY materia
    ADD CONSTRAINT pk_materia PRIMARY KEY (codigo);


--
-- Name: pk_persona; Type: CONSTRAINT; Schema: public; Owner: alumno; Tablespace: 
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (tipo_documento, numero_documento);


--
-- Name: fk_administrativo; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_administrativo FOREIGN KEY (tipo_doc_adm, numero_doc_adm) REFERENCES administrativo(tipo_documento, numero_documento);


--
-- Name: fk_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT fk_alumno FOREIGN KEY (tipo_doc_alumno, numero_doc_alumno) REFERENCES alumno(tipo_documento, numero_documento);


--
-- Name: fk_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_alumno FOREIGN KEY (tipo_documento, numero_documento) REFERENCES alumno(tipo_documento, numero_documento);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY alumno_curso
    ADD CONSTRAINT fk_curso FOREIGN KEY (anio, division, ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_curso; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_curso FOREIGN KEY (curso_anio, curso_division, curso_ciclo_lectivo) REFERENCES curso(anio, division, ciclo_lectivo);


--
-- Name: fk_docente; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_docente FOREIGN KEY (tipo_documento, numero_documento) REFERENCES docente(tipo_documento, numero_documento);


--
-- Name: fk_es_alumno; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY alumno
    ADD CONSTRAINT fk_es_alumno FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: fk_examen; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen_alumno
    ADD CONSTRAINT fk_examen FOREIGN KEY (examen) REFERENCES examen(id);


--
-- Name: fk_localidad; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT fk_localidad FOREIGN KEY (domicilio_localidad) REFERENCES localidad(codigo);


--
-- Name: fk_localidad_nacimiento; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT fk_localidad_nacimiento FOREIGN KEY (localidad_nacimiento) REFERENCES localidad(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY asistencia
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_materia; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente_curso
    ADD CONSTRAINT fk_materia FOREIGN KEY (materia) REFERENCES materia(codigo);


--
-- Name: fk_persona; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY docente
    ADD CONSTRAINT fk_persona FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: fk_persona; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY administrativo
    ADD CONSTRAINT fk_persona FOREIGN KEY (tipo_documento, numero_documento) REFERENCES persona(tipo_documento, numero_documento);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: persona; Type: ACL; Schema: public; Owner: alumno
--

REVOKE ALL ON TABLE persona FROM PUBLIC;
REVOKE ALL ON TABLE persona FROM alumno;
GRANT ALL ON TABLE persona TO alumno;
GRANT ALL ON TABLE persona TO postgres;


--
-- PostgreSQL database dump complete
--


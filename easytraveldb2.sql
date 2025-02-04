--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accommodations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accommodations (
    accommodation_id integer NOT NULL,
    accommodation_name character varying(100) NOT NULL,
    destination_id integer,
    room_type character varying(50) NOT NULL,
    price_per_night numeric(10,2) NOT NULL,
    amenities text
);


ALTER TABLE public.accommodations OWNER TO postgres;

--
-- Name: accommodations_accommodation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accommodations_accommodation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accommodations_accommodation_id_seq OWNER TO postgres;

--
-- Name: accommodations_accommodation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accommodations_accommodation_id_seq OWNED BY public.accommodations.accommodation_id;


--
-- Name: bookingpromotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookingpromotions (
    booking_id integer NOT NULL,
    promotion_id integer NOT NULL
);


ALTER TABLE public.bookingpromotions OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id integer NOT NULL,
    customer_id integer,
    flight_id integer,
    accommodation_id integer,
    transfer_id integer,
    total_price numeric(10,2) NOT NULL,
    booking_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'pending'::character varying
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_booking_id_seq OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_booking_id_seq OWNED BY public.bookings.booking_id;


--
-- Name: bookingservices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookingservices (
    booking_id integer NOT NULL,
    service_id integer NOT NULL
);


ALTER TABLE public.bookingservices OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role_id integer,
    loyalty_points integer DEFAULT 0
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: destinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.destinations (
    destination_id integer NOT NULL,
    destination_name character varying(100) NOT NULL,
    region character varying(50) NOT NULL,
    country character varying(50) NOT NULL
);


ALTER TABLE public.destinations OWNER TO postgres;

--
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    airline character varying(100) NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    origin character varying(100) NOT NULL,
    destination_id integer,
    seat_class character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    capacity integer NOT NULL
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- Name: customerbookingdetails; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customerbookingdetails AS
 SELECT c.customer_id,
    c.first_name,
    c.last_name,
    b.booking_id,
    d.destination_name,
    f.airline,
    a.accommodation_name,
    b.total_price
   FROM ((((public.customers c
     JOIN public.bookings b ON ((c.customer_id = b.customer_id)))
     JOIN public.flights f ON ((b.flight_id = f.flight_id)))
     JOIN public.accommodations a ON ((b.accommodation_id = a.accommodation_id)))
     JOIN public.destinations d ON ((f.destination_id = d.destination_id)));


ALTER VIEW public.customerbookingdetails OWNER TO postgres;

--
-- Name: customerbookings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customerbookings AS
 SELECT c.first_name,
    c.last_name,
    b.booking_id,
    d.destination_name,
    b.total_price
   FROM (((public.customers c
     JOIN public.bookings b ON ((c.customer_id = b.customer_id)))
     JOIN public.flights f ON ((b.flight_id = f.flight_id)))
     JOIN public.destinations d ON ((f.destination_id = d.destination_id)));


ALTER VIEW public.customerbookings OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: destinations_destination_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.destinations_destination_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.destinations_destination_id_seq OWNER TO postgres;

--
-- Name: destinations_destination_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.destinations_destination_id_seq OWNED BY public.destinations.destination_id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    feedback_id integer NOT NULL,
    booking_id integer,
    rating integer,
    comments text,
    CONSTRAINT feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feedback_feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_feedback_id_seq OWNED BY public.feedback.feedback_id;


--
-- Name: feedbacksummary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.feedbacksummary AS
 SELECT f.booking_id,
    f.rating,
    f.comments,
    c.first_name,
    c.last_name
   FROM ((public.feedback f
     JOIN public.bookings b ON ((f.booking_id = b.booking_id)))
     JOIN public.customers c ON ((b.customer_id = c.customer_id)));


ALTER VIEW public.feedbacksummary OWNER TO postgres;

--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flights_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flights_flight_id_seq OWNER TO postgres;

--
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;


--
-- Name: loyaltyprogram; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loyaltyprogram (
    loyalty_id integer NOT NULL,
    customer_id integer,
    points_earned integer DEFAULT 0,
    points_redeemed integer DEFAULT 0
);


ALTER TABLE public.loyaltyprogram OWNER TO postgres;

--
-- Name: loyaltymembers; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.loyaltymembers AS
 SELECT c.first_name,
    c.last_name,
    lp.points_earned,
    lp.points_redeemed
   FROM (public.customers c
     JOIN public.loyaltyprogram lp ON ((c.customer_id = lp.customer_id)));


ALTER VIEW public.loyaltymembers OWNER TO postgres;

--
-- Name: loyaltyprogram_loyalty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loyaltyprogram_loyalty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyaltyprogram_loyalty_id_seq OWNER TO postgres;

--
-- Name: loyaltyprogram_loyalty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loyaltyprogram_loyalty_id_seq OWNED BY public.loyaltyprogram.loyalty_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    booking_id integer,
    payment_method character varying(50) NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    promotion_id integer NOT NULL,
    promotion_name character varying(100) NOT NULL,
    discount_percentage numeric(5,2) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_loyalty_exclusive boolean DEFAULT false
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- Name: promotions_promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotions_promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_promotion_id_seq OWNER TO postgres;

--
-- Name: promotions_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_promotion_id_seq OWNED BY public.promotions.promotion_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_service_id_seq OWNER TO postgres;

--
-- Name: services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_service_id_seq OWNED BY public.services.service_id;


--
-- Name: taxitransfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxitransfers (
    transfer_id integer NOT NULL,
    destination_id integer,
    transfer_type character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    special_requests text
);


ALTER TABLE public.taxitransfers OWNER TO postgres;

--
-- Name: taxitransfers_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxitransfers_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.taxitransfers_transfer_id_seq OWNER TO postgres;

--
-- Name: taxitransfers_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxitransfers_transfer_id_seq OWNED BY public.taxitransfers.transfer_id;


--
-- Name: accommodations accommodation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accommodations ALTER COLUMN accommodation_id SET DEFAULT nextval('public.accommodations_accommodation_id_seq'::regclass);


--
-- Name: bookings booking_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN booking_id SET DEFAULT nextval('public.bookings_booking_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: destinations destination_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations ALTER COLUMN destination_id SET DEFAULT nextval('public.destinations_destination_id_seq'::regclass);


--
-- Name: feedback feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN feedback_id SET DEFAULT nextval('public.feedback_feedback_id_seq'::regclass);


--
-- Name: flights flight_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);


--
-- Name: loyaltyprogram loyalty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram ALTER COLUMN loyalty_id SET DEFAULT nextval('public.loyaltyprogram_loyalty_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: promotions promotion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promotion_id SET DEFAULT nextval('public.promotions_promotion_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.services_service_id_seq'::regclass);


--
-- Name: taxitransfers transfer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxitransfers ALTER COLUMN transfer_id SET DEFAULT nextval('public.taxitransfers_transfer_id_seq'::regclass);


--
-- Data for Name: accommodations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accommodations (accommodation_id, accommodation_name, destination_id, room_type, price_per_night, amenities) FROM stdin;
1	Beacons Hotel	1	Private Suite	400.00	WiFi, Pool, Gym, room service
2	Hotel Paris	2	Deluxe Room	200.00	WiFi, Pool, Gym
3	Mystic Villa	3	Private Villa	700.00	Beach Access, Private Pool, Renatl Car
4	Villa Bali	4	Private Villa	300.00	Private Pool, Beach Access
\.


--
-- Data for Name: bookingpromotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookingpromotions (booking_id, promotion_id) FROM stdin;
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, customer_id, flight_id, accommodation_id, transfer_id, total_price, booking_date, status) FROM stdin;
1	1	1	1	\N	700.00	2025-02-04 12:34:36.892087	pending
2	2	2	2	\N	500.00	2025-02-04 12:34:36.892087	pending
3	3	3	3	\N	1800.00	2025-02-04 12:34:36.892087	pending
4	4	4	4	\N	1300.00	2025-02-04 12:34:36.892087	pending
5	1	1	1	\N	700.00	2025-02-04 13:10:36.37973	pending
\.


--
-- Data for Name: bookingservices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookingservices (booking_id, service_id) FROM stdin;
1	1
2	2
3	3
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, first_name, last_name, email, password_hash, role_id, loyalty_points) FROM stdin;
2	Stiles	McCall	smccall23@gmail.com	s67th	1	0
3	Zeke	Argent	zargent89@gmail.com	zeke123	1	0
4	Mia	Moline	mmolene@gmail.com	3386mm	1	0
1	Tina	Kales	tkales@gmail.com	k1k1k1	4	0
\.


--
-- Data for Name: destinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.destinations (destination_id, destination_name, region, country) FROM stdin;
1	Paris	Ile-de-France	France
2	Oryol	Moscow	Russia
3	Rome	Milan	Italy
4	Victoria falls	sub-saharan	Zimbabwe
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (feedback_id, booking_id, rating, comments) FROM stdin;
1	1	5	Excellent service!
2	2	4	Great experience, but the flight was delayed.
3	3	1	Poor service!
4	4	5	Amazing Service. I got assisted with everything in a very professional way.
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (flight_id, airline, departure_time, arrival_time, origin, destination_id, seat_class, price, capacity) FROM stdin;
1	AirFrance	2024-09-24 11:00:00	2024-09-25 16:00:00	Paris	1	Economy	500.00	200
2	Qatar Airways	2024-06-05 12:20:00	2024-06-06 17:00:00	Dubai	2	Business	1800.00	20
3	Garuda Indonesia	2024-12-05 08:00:00	2024-12-06 12:00:00	Sydney	2	Business	1200.00	50
4	AirFrance	2024-08-15 10:00:00	2024-08-16 14:00:00	New York	1	Economy	500.00	200
\.


--
-- Data for Name: loyaltyprogram; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loyaltyprogram (loyalty_id, customer_id, points_earned, points_redeemed) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, booking_id, payment_method, amount, payment_date) FROM stdin;
1	1	Credit Card	700.00	2025-02-04 12:43:32.09969
2	2	Bank Transfer	500.00	2025-02-04 12:43:32.09969
3	3	Bank Transfer	1800.00	2025-02-04 12:43:32.09969
4	4	Credit Card	1300.00	2025-02-04 12:43:32.09969
5	5	Credit Card	700.00	2025-02-04 13:10:36.37973
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, promotion_name, discount_percentage, start_date, end_date, is_loyalty_exclusive) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
1	Customer
2	TravelAgent
3	Admin
4	PremiumCustomer
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, service_name, price) FROM stdin;
1	Extra Baggage	50.00
2	Guided Tour	100.00
3	Car Rental	75.00
\.


--
-- Data for Name: taxitransfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxitransfers (transfer_id, destination_id, transfer_type, price, special_requests) FROM stdin;
\.


--
-- Name: accommodations_accommodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accommodations_accommodation_id_seq', 4, true);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 6, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- Name: destinations_destination_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.destinations_destination_id_seq', 4, true);


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_feedback_id_seq', 4, true);


--
-- Name: flights_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_flight_id_seq', 4, true);


--
-- Name: loyaltyprogram_loyalty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loyaltyprogram_loyalty_id_seq', 1, false);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 5, true);


--
-- Name: promotions_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promotion_id_seq', 1, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 4, true);


--
-- Name: services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_service_id_seq', 3, true);


--
-- Name: taxitransfers_transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taxitransfers_transfer_id_seq', 1, false);


--
-- Name: accommodations accommodations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT accommodations_pkey PRIMARY KEY (accommodation_id);


--
-- Name: bookingpromotions bookingpromotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingpromotions
    ADD CONSTRAINT bookingpromotions_pkey PRIMARY KEY (booking_id, promotion_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: bookingservices bookingservices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingservices
    ADD CONSTRAINT bookingservices_pkey PRIMARY KEY (booking_id, service_id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: destinations destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (destination_id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);


--
-- Name: loyaltyprogram loyaltyprogram_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram
    ADD CONSTRAINT loyaltyprogram_pkey PRIMARY KEY (loyalty_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (promotion_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- Name: taxitransfers taxitransfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxitransfers
    ADD CONSTRAINT taxitransfers_pkey PRIMARY KEY (transfer_id);


--
-- Name: accommodations accommodations_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT accommodations_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(destination_id) ON DELETE CASCADE;


--
-- Name: bookingpromotions bookingpromotions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingpromotions
    ADD CONSTRAINT bookingpromotions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: bookingpromotions bookingpromotions_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingpromotions
    ADD CONSTRAINT bookingpromotions_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- Name: bookings bookings_accommodation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_accommodation_id_fkey FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(accommodation_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: bookings bookings_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_transfer_id_fkey FOREIGN KEY (transfer_id) REFERENCES public.taxitransfers(transfer_id) ON DELETE SET NULL;


--
-- Name: bookingservices bookingservices_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingservices
    ADD CONSTRAINT bookingservices_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: bookingservices bookingservices_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookingservices
    ADD CONSTRAINT bookingservices_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id) ON DELETE CASCADE;


--
-- Name: customers customers_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: feedback feedback_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: flights flights_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(destination_id) ON DELETE CASCADE;


--
-- Name: loyaltyprogram loyaltyprogram_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram
    ADD CONSTRAINT loyaltyprogram_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: taxitransfers taxitransfers_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxitransfers
    ADD CONSTRAINT taxitransfers_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(destination_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


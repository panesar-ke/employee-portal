-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
DO $$ BEGIN
 CREATE TYPE "key_status" AS ENUM('default', 'valid', 'invalid', 'expired');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "key_type" AS ENUM('aead-ietf', 'aead-det', 'hmacsha512', 'hmacsha256', 'auth', 'shorthash', 'generichash', 'kdf', 'secretbox', 'secretstream', 'stream_xchacha20');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "aal_level" AS ENUM('aal1', 'aal2', 'aal3');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_type" AS ENUM('totp', 'webauthn');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_status" AS ENUM('unverified', 'verified');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "code_challenge_method" AS ENUM('s256', 'plain');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "userRoleEnum" AS ENUM('SUPER ADMIN', 'ADMIN', 'STANDARD USER');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "discountTypeEnum" AS ENUM('AMOUNT', 'PERCENTAGE', 'NONE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "vatTypeEnum" AS ENUM('INCLUSIVE', 'EXCLUSIVE', 'NONE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "stockMovementTypeEnum" AS ENUM('OPENING_BAL', 'CONVERSION_OUT', 'CONVERSION_IN', 'CONVERSION', 'TRANSFER', 'ISSUE', 'GRN');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "employeeCategory" AS ENUM('NON-UNIONISABLE', 'MANAGEMENT', 'UNIONISABLE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "employeeStatus" AS ENUM('RETIRED', 'RESIGNED', 'TERMINATED', 'ACTIVE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "employmentType" AS ENUM('NO CONTRACT', 'INTERN', 'CASUAL', 'CONTRACT', 'PERMANENT');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "genderEnum" AS ENUM('FEMALE', 'MALE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "maritalStatusEnum" AS ENUM('WIDOWED', 'DIVORCED', 'MARRIED', 'SINGLE');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "bloodTypeEnum" AS ENUM('O', 'AB', 'B', 'A');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "forms" (
	"id" serial PRIMARY KEY NOT NULL,
	"form_name" varchar(100) NOT NULL,
	"module" varchar NOT NULL,
	"module_id" integer NOT NULL,
	"path" varchar NOT NULL,
	"menu_order" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "session" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"expires_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "uoms" (
	"id" serial PRIMARY KEY NOT NULL,
	"uom" varchar NOT NULL,
	"abbreviation" varchar(50) NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "vats" (
	"id" serial PRIMARY KEY NOT NULL,
	"value" integer NOT NULL,
	"vat_name" varchar(20) NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "vendors" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"vendor_name" text NOT NULL,
	"contact" varchar(20),
	"kra_pin" varchar(50),
	"address" text,
	"email" varchar,
	"contact_person" varchar,
	"active" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "product_categories" (
	"id" serial PRIMARY KEY NOT NULL,
	"category_name" varchar NOT NULL,
	"active" boolean DEFAULT true
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "projects" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"project_name" varchar NOT NULL,
	"active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "mrq_headers" (
	"id" bigint PRIMARY KEY NOT NULL,
	"reference" text NOT NULL,
	"document_date" timestamp NOT NULL,
	"linked" boolean DEFAULT false NOT NULL,
	"created_by" uuid NOT NULL,
	"created_on" timestamp DEFAULT now() NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "orders_header" (
	"id" bigint PRIMARY KEY NOT NULL,
	"reference" text NOT NULL,
	"document_date" date NOT NULL,
	"vendor_id" uuid NOT NULL,
	"bill_no" varchar,
	"mrq_id" integer,
	"bill_date" date,
	"created_by" uuid NOT NULL,
	"created_on" timestamp DEFAULT now() NOT NULL,
	"is_deleted" boolean DEFAULT false,
	"vat_type" "vatTypeEnum" DEFAULT 'NONE' NOT NULL,
	"vat_id" integer,
	CONSTRAINT "orders_header_reference_unique" UNIQUE("reference")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "grns_details" (
	"id" uuid DEFAULT gen_random_uuid() NOT NULL,
	"header_id" integer NOT NULL,
	"item_id" uuid NOT NULL,
	"qty" integer NOT NULL,
	"rate" numeric NOT NULL,
	"remarks" text
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "grns_header" (
	"id" bigint PRIMARY KEY NOT NULL,
	"receipt_date" date DEFAULT now() NOT NULL,
	"invoice_no" varchar,
	"vendor_id" uuid,
	"created_by" uuid NOT NULL,
	"created_on" date DEFAULT now(),
	"is_deleted" boolean DEFAULT false
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "departments" (
	"id" serial PRIMARY KEY NOT NULL,
	"department_name" varchar NOT NULL,
	"is_production" boolean DEFAULT true NOT NULL,
	"production_flow" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "material_issues_header" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"issue_no" integer NOT NULL,
	"issue_date" date DEFAULT now() NOT NULL,
	"staff_name" varchar,
	"jobcard_no" varchar(6),
	"text" text,
	"issued_by" uuid NOT NULL,
	"created_on" date DEFAULT now() NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	CONSTRAINT "material_issues_header_issue_no_unique" UNIQUE("issue_no")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "stock_movements" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"transaction_date" date DEFAULT now() NOT NULL,
	"item_id" uuid NOT NULL,
	"qty" numeric NOT NULL,
	"transaction_type" "stockMovementTypeEnum" NOT NULL,
	"transaction_id" text NOT NULL,
	"created_by" uuid NOT NULL,
	"created_on" date DEFAULT now(),
	"remarks" text,
	"is_deleted" boolean DEFAULT false
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "conversions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"conversion_date" date DEFAULT now() NOT NULL,
	"converting_item" uuid NOT NULL,
	"converting_quantity" numeric NOT NULL,
	"converted_item" uuid NOT NULL,
	"converted_quantity" numeric NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"contact" varchar(10) NOT NULL,
	"password" text NOT NULL,
	"user_type" "userRoleEnum" DEFAULT 'STANDARD USER' NOT NULL,
	"contact_verified" timestamp,
	"email" text,
	"image" text,
	"default_menu" varchar,
	"active" boolean DEFAULT true NOT NULL,
	"role" integer,
	"prompt_password_change" boolean DEFAULT false,
	"reset_token" text,
	CONSTRAINT "users_contact_unique" UNIQUE("contact"),
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "roles" (
	"id" serial PRIMARY KEY NOT NULL,
	"role" varchar NOT NULL,
	"menu_name" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "mrq_details" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"header_id" integer NOT NULL,
	"request_id" bigint NOT NULL,
	"project_id" uuid NOT NULL,
	"item_id" uuid,
	"unit_id" integer NOT NULL,
	"qty" numeric NOT NULL,
	"remarks" varchar,
	"linked" boolean DEFAULT false NOT NULL,
	"service_id" uuid,
	CONSTRAINT "mrq_details_request_id_unique" UNIQUE("request_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "services" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"service_name" varchar NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"service_fee" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "temp_debtors" (
	"id" text PRIMARY KEY NOT NULL,
	"debtors_name" varchar(150) NOT NULL,
	"email" varchar NOT NULL,
	"contact" varchar,
	"debt_amount" numeric NOT NULL,
	CONSTRAINT "temp_debtors_email_unique" UNIQUE("email"),
	CONSTRAINT "temp_debtors_contact_unique" UNIQUE("contact")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "employees_otherdetails" (
	"employee_id" integer NOT NULL,
	"nhif" varchar,
	"nssf" varchar,
	"kra_pin" varchar,
	"allergies" boolean DEFAULT false NOT NULL,
	"allegry_description" varchar,
	"illness" boolean DEFAULT false NOT NULL,
	"illness_description" varchar,
	"conviction" boolean DEFAULT false NOT NULL,
	"conviction_description" varchar,
	"blood_type" "bloodTypeEnum"
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "designations" (
	"id" integer PRIMARY KEY NOT NULL,
	"designation_name" varchar(150) NOT NULL,
	"active" boolean DEFAULT true NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "employees_children" (
	"employee_id" integer NOT NULL,
	"childname" varchar,
	"dob" date
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "employees" (
	"id" integer PRIMARY KEY NOT NULL,
	"reference" uuid DEFAULT gen_random_uuid() NOT NULL,
	"surname" varchar(255) NOT NULL,
	"other_names" varchar NOT NULL,
	"gender" "genderEnum" NOT NULL,
	"dob" date NOT NULL,
	"marital_status" "maritalStatusEnum",
	"id_no" varchar(15),
	"payroll_no" varchar(6),
	"department" integer NOT NULL,
	"designation" integer NOT NULL,
	"employment_type" "employmentType",
	"contract_date" date DEFAULT now(),
	"joining_date" date DEFAULT now(),
	"contract_duration" integer DEFAULT 0 NOT NULL,
	"expiry_date" date,
	"employee_category" "employeeCategory" NOT NULL,
	"spouse_name" varchar(255),
	"spouse_contact" varchar(15),
	"employee_status" "employeeStatus" DEFAULT 'ACTIVE' NOT NULL,
	"image_url" text,
	"remarks" text,
	"is_new" boolean DEFAULT true NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "employees_contacts" (
	"employee_id" integer NOT NULL,
	"primary_contact" varchar(15),
	"alternative_contact" varchar,
	"address" varchar,
	"postal_code" varchar(5),
	"estate" varchar,
	"street" varchar,
	"county_id" integer,
	"district" varchar,
	"location" varchar,
	"village" varchar,
	"email_address" varchar(255)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "employees_noks" (
	"employee_id" integer NOT NULL,
	"name_one" varchar,
	"relation_one" varchar,
	"contact_one" varchar(15),
	"name_two" varchar,
	"relation_two" varchar,
	"contact_two" varchar(15)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "counties" (
	"id" integer PRIMARY KEY NOT NULL,
	"county" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "products" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"product_name" varchar NOT NULL,
	"category_id" integer NOT NULL,
	"uom_id" integer,
	"buying_price" numeric,
	"active" boolean DEFAULT true,
	"stock_item" boolean DEFAULT true,
	"is_peace" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "orders_details" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"header_id" integer NOT NULL,
	"project_id" uuid NOT NULL,
	"item_id" uuid,
	"qty" numeric NOT NULL,
	"rate" numeric NOT NULL,
	"discount_type" "discountTypeEnum" DEFAULT 'NONE' NOT NULL,
	"discount" numeric NOT NULL,
	"discounted_amount" numeric NOT NULL,
	"vat_type" "vatTypeEnum",
	"vat_id" integer,
	"amount_exclusive" numeric NOT NULL,
	"vat" numeric NOT NULL,
	"amount_inclusive" numeric NOT NULL,
	"received" boolean DEFAULT false,
	"service_id" uuid,
	"request_id" bigint
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "user_roles" (
	"user_id" uuid NOT NULL,
	"role_id" integer NOT NULL,
	CONSTRAINT "user_roles_role_id_user_id_pk" PRIMARY KEY("user_id","role_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "verification_tokens" (
	"identifier" text NOT NULL,
	"token" text NOT NULL,
	"expires" timestamp NOT NULL,
	CONSTRAINT "verification_tokens_identifier_token_pk" PRIMARY KEY("identifier","token")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "accounts" (
	"user_id" uuid NOT NULL,
	"type" text NOT NULL,
	"provider" text NOT NULL,
	"provider_account_id" text NOT NULL,
	"refresh_token" text,
	"access_token" text,
	"expires_at" integer,
	"token_type" text,
	"scope" text,
	"id_token" text,
	"session_state" text,
	CONSTRAINT "accounts_provider_provider_account_id_pk" PRIMARY KEY("provider","provider_account_id")
);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "vendor_name_idx" ON "vendors" ("vendor_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "project_name_idx" ON "projects" ("project_name");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "contact_idx" ON "users" ("contact");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "user_name_idx" ON "users" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "employee_surname_idx" ON "employees" ("surname");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "employee_othernames_idx" ON "employees" ("other_names");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "product_name_idx" ON "products" ("product_name");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "session" ADD CONSTRAINT "session_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_headers" ADD CONSTRAINT "mrq_headers_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_header" ADD CONSTRAINT "orders_header_vat_id_vats_id_fk" FOREIGN KEY ("vat_id") REFERENCES "public"."vats"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_header" ADD CONSTRAINT "orders_header_mrq_id_mrq_headers_id_fk" FOREIGN KEY ("mrq_id") REFERENCES "public"."mrq_headers"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_header" ADD CONSTRAINT "orders_header_vendor_id_vendors_id_fk" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_header" ADD CONSTRAINT "orders_header_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "grns_details" ADD CONSTRAINT "grns_details_header_id_grns_header_id_fk" FOREIGN KEY ("header_id") REFERENCES "public"."grns_header"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "grns_details" ADD CONSTRAINT "grns_details_item_id_products_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."products"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "grns_header" ADD CONSTRAINT "grns_header_vendor_id_vendors_id_fk" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "grns_header" ADD CONSTRAINT "grns_header_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "material_issues_header" ADD CONSTRAINT "material_issues_header_issued_by_users_id_fk" FOREIGN KEY ("issued_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_item_id_products_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."products"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "conversions" ADD CONSTRAINT "conversions_converting_item_products_id_fk" FOREIGN KEY ("converting_item") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "conversions" ADD CONSTRAINT "conversions_converted_item_products_id_fk" FOREIGN KEY ("converted_item") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "users" ADD CONSTRAINT "users_role_roles_id_fk" FOREIGN KEY ("role") REFERENCES "public"."roles"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_details" ADD CONSTRAINT "mrq_details_unit_id_uoms_id_fk" FOREIGN KEY ("unit_id") REFERENCES "public"."uoms"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_details" ADD CONSTRAINT "mrq_details_service_id_services_id_fk" FOREIGN KEY ("service_id") REFERENCES "public"."services"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_details" ADD CONSTRAINT "mrq_details_item_id_products_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_details" ADD CONSTRAINT "mrq_details_header_id_mrq_headers_id_fk" FOREIGN KEY ("header_id") REFERENCES "public"."mrq_headers"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "mrq_details" ADD CONSTRAINT "mrq_details_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees_otherdetails" ADD CONSTRAINT "employees_otherdetails_employee_id_employees_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees_children" ADD CONSTRAINT "employees_children_employee_id_employees_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees" ADD CONSTRAINT "employees_designation_designations_id_fk" FOREIGN KEY ("designation") REFERENCES "public"."designations"("id") ON DELETE restrict ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees" ADD CONSTRAINT "employees_department_departments_id_fk" FOREIGN KEY ("department") REFERENCES "public"."departments"("id") ON DELETE restrict ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees_contacts" ADD CONSTRAINT "employees_contacts_employee_id_employees_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees_contacts" ADD CONSTRAINT "employees_contacts_county_id_counties_id_fk" FOREIGN KEY ("county_id") REFERENCES "public"."counties"("id") ON DELETE restrict ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "employees_noks" ADD CONSTRAINT "employees_noks_employee_id_employees_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employees"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "products" ADD CONSTRAINT "products_category_id_product_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "products" ADD CONSTRAINT "products_uom_id_uoms_id_fk" FOREIGN KEY ("uom_id") REFERENCES "public"."uoms"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_details" ADD CONSTRAINT "orders_details_vat_id_vats_id_fk" FOREIGN KEY ("vat_id") REFERENCES "public"."vats"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_details" ADD CONSTRAINT "orders_details_service_id_services_id_fk" FOREIGN KEY ("service_id") REFERENCES "public"."services"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_details" ADD CONSTRAINT "orders_details_item_id_products_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_details" ADD CONSTRAINT "orders_details_header_id_orders_header_id_fk" FOREIGN KEY ("header_id") REFERENCES "public"."orders_header"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "orders_details" ADD CONSTRAINT "orders_details_project_id_projects_id_fk" FOREIGN KEY ("project_id") REFERENCES "public"."projects"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_roles_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "accounts" ADD CONSTRAINT "accounts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

*/
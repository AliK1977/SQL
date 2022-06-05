/*Charlie's Chocolate Factory company produces chocolates. The following product information is stored:
product name, product ID, and quantity on hand.


These chocolates are made up of many components.
Each component can be supplied by one or more suppliers. 
The following component information is kept: component ID, name, description, quantity on hand, 
suppliers who supply them, when and how much they supplied, and products in which they are used.
On the other hand following supplier information is stored: supplier ID, name, and activation status.
Assumptions
A supplier can exist without providing components.
A component does not have to be associated with a supplier. It may already have been in the inventory.
A component does not have to be associated with a product. Not all components are used in products.
A product cannot exist without components.*/

CREATE DATABASE Charlie_Chocolate_Factory

CREATE TABLE Product

(prod_name VARCHAR(50) NOT NULL,
prod_id int IDENTITY (1, 1) PRIMARY KEY,
quantity int
);
 
CREATE TABLE Supplier 

(supp_id int IDENTITY (1, 1) PRIMARY KEY,
supp_name VARCHAR(50) NOT NULL,
supp_location VARCHAR(50),
is_active bit NULL
);

CREATE TABLE Component

(comp_id int IDENTITY (1, 1) PRIMARY KEY,
comp_name VARCHAR(50) NOT NULL,
description VARCHAR(50),
quantity_comp int
);

CREATE TABLE Prod_Comp

(prod_id int PRIMARY KEY,
 Comp_id int ,
 quantity_comp int,

 FOREIGN KEY (comp_id)
 REFERENCES component(comp_id),
 FOREIGN KEY (prod_id)
 REFERENCES product (prod_id)
);

CREATE TABLE Comp_Supp

(supp_id int PRIMARY KEY,
 comp_id int,
 order_date date,
 quantity int,
 
 FOREIGN KEY(Supp_id)
 REFERENCES Supplier(supp_id),
 FOREIGN KEY (comp_id)
 REFERENCES Component(comp_id)
 );
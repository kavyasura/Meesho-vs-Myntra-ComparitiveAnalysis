CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  age INT,
  gender VARCHAR(10),
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100)
);


CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  product_category VARCHAR(50),
  platform VARCHAR(20),
  price DECIMAL(10,2),
  weight DECIMAL(5,2),
  stock INT,
  ratings DECIMAL(3,1)
);


CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  city VARCHAR(100),
  state VARCHAR(100),
  date DATE,
  time TIME,
  month VARCHAR(20),
  total_bill DECIMAL(10,2),
  day_name VARCHAR(20),
  quantity INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);


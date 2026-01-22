create database if not exists elearning_platform;
use elearning_platform;

create table learners (
	learner_id int auto_increment primary key,
    learner_name varchar(50) not null,
    email varchar(100) unique not null,
    country varchar(100) not null,
    registration_date date not null
);

create table courses (
	course_id int auto_increment primary key,
    course_title varchar(100) not null,
    category_id int not null,
    price decimal(10,2) not null,
    created_date date not null
);

create table purchases (
	purchase_id int auto_increment primary key,
    learner_id int not null,
    course_id int not null,
    purchase_date date not null,
    payment_status varchar(50) not null,
    foreign key (learner_id) references learners(learner_id),
    foreign key (course_id) references courses(course_id)
);

insert into learners (learner_name, email, country, registration_date) values
('Praveen Nataraj', 'praveennataraj@gmail.com', 'India', '2024-01-10'),
('Pradeep Nataraj', 'pradeepnataraj@gmail.com', 'USA', '2024-02-05'),
('Maheshwari Nataraj', 'maheshwarinataraj@gmail.com', 'UK', '2024-02-18'),
('Dhushanthani Pradeep', 'dhushanthanipradeep@gmail.com', 'India', '2024-03-01'),
('Geethalakshmi Thangamuthu', 'geethathangam@gmail.com', 'UK', '2024-03-12');

insert into courses (course_title, category_id, price, created_date) values
('Python for Data Science', 1, 3000.00, '2024-01-15'),
('Machine Learning Basics', 1, 4000.00, '2024-02-10'),
('Java Programming', 2, 2500.00, '2024-01-20'),
('Business Analytics', 3, 3500.00, '2024-02-25'),
('UI/UX Design Fundamentals', 4, 2000.00, '2024-03-05');

INSERT INTO purchases (learner_id, course_id, purchase_date, payment_status) VALUES
(1, 1, '2024-03-10', 'Completed'),
(1, 2, '2024-03-15', 'Completed'),
(2, 3, '2024-03-18', 'Completed'),
(3, 1, '2024-03-20', 'Completed'),
(4, 4, '2024-03-22', 'Pending'),
(5, 5, '2024-03-25', 'Completed');

select * from learners;
select * from courses;
select * from purchases;

-- Q1. Display each learner’s total spending (quantity × unit_price) along with their country.

SELECT l.learner_name, l.country, SUM(c.price) AS total_spending
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id;


-- Q2. Find the top 3 most purchased courses based on total quantity sold.

SELECT course_id, COUNT(*) as total_sold
FROM purchases
GROUP BY course_id
ORDER BY total_sold DESC
LIMIT 3;

-- Q3. Show each course title total revenue and the number of unique learners who purchased from that category.

SELECT c.course_title, 
       SUM(c.price) AS total_revenue, 
       COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_title;

-- Q4. List all learners who have purchased courses from more than one category.

SELECT DISTINCT l.learner_id, l.learner_name
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.learner_name
HAVING COUNT(DISTINCT c.category_id) > 1;

-- Q5. Identify courses that have not been purchased at all.

SELECT course_id, course_title
FROM courses
WHERE course_id NOT IN (SELECT course_id FROM purchases);


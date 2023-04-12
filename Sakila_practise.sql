Select * from actor;
#Display the first and last names of all actors from the table actor
Select first_name as First_Name, last_name as Last_Name
from actor;

#Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select upper(concat(First_name ,'  ', last_name)) as 'Actor_Name'
from actor;

#You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, “Joe.” What is one query would you use to obtain this information?
select actor_id as Actor_ID, first_name as First_Name,last_name as Last_Name
from actor
where first_name like 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
select Actor_id , First_name,Last_name 
from actor
where last_name like ('%gen');

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id,first_name,last_name
from actor
where last_name like ('%li%')
order by last_name,first_name;

#Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select * from country;
Select country_id,country
from country
where country in ('Afghanistan', 'Bangladesh','China');

# Add a middle_name column to the table actor. Position it between first_name and last_name

alter table actor
add column middle_name varchar(20)after first_name;
select *
	from actor;
    
#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

alter table actor
modify column middle_name blob;
select * from actor;

#Now delete the middle_name column.	

alter table actor
drop column middle_name ;
select* from actor;

#4a. List the last names of actors, as well as how many actors have that last name.

select last_name as Actor_Last_Name, count(last_name) as Count_of_last_name
from actor
group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name as Last_Name ,count(last_Name) as Count_of_Last_Name
from actor
group by last_name
having count(last_name)> 1;


#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo’s second cousin’s husband’s yoga teacher. Write a query to fix the record.
 
 select first_name, last_name from actor
 where first_name ='Groucho' and last_name ='williams';
 
 update actor
 set first_name ='Harpo'
 where first_name = 'Groucho' and last_name ='williams';
 
 select * from actor
 where last_name = 'williams';
 
 #4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER!
 
 select first_name, last_name
 from actor
 where first_name ='Harpo';
 
 update actor
 set first_name = 'Groucho'
 where first_name = 'Harpo' and last_name ='williams';
 
 update actor
 set first_name = case
  when first_name ='Harpo' then 'Groucho'
  when first_name ='Groucho' then 'Mucho Groucho'
  else first_name
  end;
  
  select * from actor
  where first_name = 'Groucho';
  
 # 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
  create table address_new (address_id integer(11) NOT NULL,
    		address varchar(30) NOT NULL,
    		adress2 varchar(30) NOT NULL,
    		district varchar(30) NOT NULL,
    		city_id integer(11) NOT NULL,
    		postal_code integer(11) NOT NULL,
    		phone integer(10) NOT NULL,
    		location varchar(30) NOT NULL,
    		last_update datetime
            );
            select * from address_new;
            
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
  
  select s.first_name as First_Name , s.last_name as Last_Name, a.address
  from staff s
  left join address a on s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

Select concat(s.first_name,' - ',s.last_name) as 'Staff_Member', sum(p.amount) as 'Total_Amount'
from payment p 
join staff s
on p.staff_id = s.staff_id
where  payment_date like '2005-08%'
group by p.staff_id
order by Total_Amount desc;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select count(fa.actor_id) as Count_of_Actors,f.title as Movie_title
from film_actor fa
join film f
on fa.film_id = f.film_id
group by f.title
order by Count_of_Actors desc;

select f.title as 'Film', count(fa.actor_id) as 'Number of Actors'
	from film as f
	join film_actor as fa
	on f.film_id = fa.film_id
	group by f.title;
    
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
    select * from inventory;
    select * from  film;
    
    select f.title as Movie_Title, count(i.inventory_id) as Count_of_Inventory_ID
    from film f
    join inventory i
    on f.film_id = i.inventory_id
    where f.title = ('Hunchback Impossible')
    group by f.title;
    
#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
  
  select * from payment ;
  select * from customer;
  
  Select concat (c.first_name , ' ' ,c. Last_name) as Customers, sum(p.amount) as Total_Amount_Paid_in_USD 
  from payment p
  join customer c
  on p.customer_id=c.customer_id
  group by Customers;
  
 #7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
 select * from language;
 select * from film;
 
Select f.title
from film f
where f.language_id = (select language_id from language  where name = 'English')
and f.title like '%k' or '%Q';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
 
 select concat(first_name,' ', last_name) as Actors_Name_in_Alone_Trip
 from actor where actor_id in
 (select actor_id from film_actor where film_id =
 (select film_id from film where title = 'Alone Trip'));

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from address;
select * from customer;

select concat(c.first_name,' ',c.last_name) as 'Name', c.email as 'E-mail'
	from customer as c
	join address as a on c.address_id = a.address_id
	join city as cy on a.city_id = cy.city_id
	join country as ct on ct.country_id = cy.country_id
	where ct.country = 'Canada';
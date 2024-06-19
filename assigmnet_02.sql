use opt_db;
select
    (select concat(product_name, ': ', cnt)
     from (
         select product_name, count(*) as cnt
         from opt_orders o
         join opt_products p on o.product_id = p.product_id
         where o.order_date > '2020-01-01'
         group by product_name
         order by cnt asc
         limit 1
     ) as sub1
    ) as min_cnt,

    (select concat(product_name, ': ', cnt)
     from (
         select product_name, count(*) as cnt
         from opt_orders o
         join opt_products p on o.product_id = p.product_id
         where o.order_date > '2020-01-01'
         group by product_name
         order by cnt desc
         limit 1
     ) as sub2
    ) as max_cnt;
   
create index idx_order_date on opt_orders(order_date);
create index idx_product_id on opt_orders(product_id);
create index idx_product_id on opt_products(product_id);

DROP INDEX idx_order_date ON opt_orders;
DROP INDEX idx_product_id ON opt_orders;
DROP INDEX idx_product_id ON opt_products;

with cte1 as (
    select p.product_name, count(o.order_id) as cnt
    from opt_orders o
    join opt_products p on o.product_id = p.product_id
    where o.order_date > '2020-01-01'
    group by p.product_name
),
cte2 as (
    select product_name, cnt
    from cte1
    order by cnt asc
    limit 1
),
cte3 as (
    select product_name, cnt
    from cte1
    order by cnt desc
    limit 1
)
select
    (select concat(product_name, ': ', cnt) from cte2) as min_cnt,
    (select concat(product_name, ': ', cnt) from cte3) as max_cnt;
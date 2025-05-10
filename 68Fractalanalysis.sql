USE practice;
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(50),
    house VARCHAR(50)
);

-- Create the 'battle' table
CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(100),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(50),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);

delete from king;
INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

delete from battle;
-- Insert data into the 'battle' table
INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
-- for each region find house which has won maximum no of battles. display region, house and no of wins
select * from battle;
select * from king;

-- Determine how many battles have each house won in a particular region. Make sure the battles are in alphabetical order.
-- house, region, no of wins
with wins as(select attacker_king as king ,region from battle 
where attacker_outcome =1
union all
select defender_king,region from battle 
where attacker_outcome =0)
select * from (
select w.region,k.house ,count(*) as wins,
rank() over(partition by w.region order by count(*) desc) as rn from wins w 
inner join King k 
on k.k_no=w.king
group by w.region,k.house) a 
where rn=1;


-- another approach 

select * from (
select b.region,k.house ,count(*) as wins,
rank() over(partition by b.region order by count(*) desc) as rn from battle b 
inner join King k 
on k.k_no=(case when b.attacker_outcome=1 then b.attacker_king else b.defender_king end)
group by b.region,k.house) a 
where rn=1;


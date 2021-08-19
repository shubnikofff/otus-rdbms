create table if not exists statistic
(
    player_name varchar(100) not null,
    player_id   int          not null,
    year_game   smallint     not null check (year_game > 0),
    points      decimal(12, 2) check (points >= 0),
    primary key (player_name, year_game)
);

truncate table statistic;
insert into statistic(player_name, player_id, year_game, points)
values ('Mike', 1, 2018, 18),
       ('Jack', 2, 2018, 14),
       ('Jackie', 3, 2018, 30),
       ('Jet', 4, 2018, 30),
       ('Luke', 1, 2019, 16),
       ('Mike', 2, 2019, 14),
       ('Jack', 3, 2019, 15),
       ('Jackie', 4, 2019, 28),
       ('Jet', 5, 2019, 25),
       ('Luke', 1, 2020, 19),
       ('Mike', 2, 2020, 17),
       ('Jack', 3, 2020, 18),
       ('Jackie', 4, 2020, 29),
       ('Jet', 5, 2020, 27);

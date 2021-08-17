create or replace function generate_text(length int) returns text as
$$
declare
    result text := '';
begin
    select array_to_string(array(select chr((65 + round(random() * 25)) :: integer)
                                 into result
                                 from generate_series(1, length)), '');
    return result;
end ;
$$ language plpgsql;

create or replace function generate_number(min int, max int) returns int as
$$
begin
    return floor(random() * (max - min + 1) + min);
end;
$$ language plpgsql;

create or replace function generate_sentence(max_words int) returns tsvector as
$$
declare
    word_number int;
    result      tsvector := '';
begin
    select generate_number(1, max_words) into word_number;
    select array_to_string(array(select generate_text(5)
                                 into result
                                 from generate_series(1, word_number)), ' ');

    return result;
end;
$$ language plpgsql;
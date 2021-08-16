create or replace function generate_text(length int) returns text as
$$
declare
    result text := '';
begin
    select array_to_string(array(select chr((65 + round(random() * 57)) :: integer)
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
$$ language 'plpgsql';
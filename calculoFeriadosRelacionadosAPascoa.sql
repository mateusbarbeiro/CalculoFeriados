do $$
declare 
    currentYear INTEGER;
    century INTEGER;
    G INTEGER;
    K INTEGER;
    I INTEGER;
    H INTEGER;
    J INTEGER;
    L INTEGER;
    easterMonth INTEGER;
    easterDay INTEGER;
    easter timestamp;
	 
    initialDate timestamp := '2020-01-01';
    finalDate timestamp := '2030-01-01';
begin
    while initialDate <=  finalDate loop
        currentYear := EXTRACT(YEAR FROM initialDate);
 
        century := currentYear / 100;
        G := currentYear % 19;
        K := ( century - 17 ) / 25;
        I := (  century - CAST( century / 4 AS INTEGER) - CAST((  century -  K ) / 3 AS INTEGER) + 19 *  G + 15 ) % 30;
        H := I - CAST( I / 28 AS INTEGER) * ( 1 * -CAST( I / 28 AS INTEGER) * CAST(29 / (  I + 1 ) AS INTEGER) ) * CAST(( ( 21 -  G ) / 11 ) AS INTEGER);
        J := (  currentYear + CAST( currentYear / 4 AS INTEGER) +  H + 2 -  century + CAST( century / 4 AS INTEGER) ) % 7;
        L := H -  J;
        easterMonth := 3 + CAST((  L + 40 ) / 44 AS INTEGER);
        easterDay :=  L + 28 - 31 * CAST((  easterMonth / 4 ) AS INTEGER);
        easter := CONCAT(CAST( currentYear AS VARCHAR(4)), '-', CAST(easterMonth AS VARCHAR(2)), '-', CAST( easterDay AS VARCHAR(2)));
 
        INSERT INTO holidays (title, holiday_day, holiday_month, holiday_year , hash, created_by, created) VALUES
            ('Páscoa', easterDay, easterMonth, CAST(currentYear AS VARCHAR(4)), '899e08e9-bc6b-4bef-be27-7a17354e583b', 1, initialDate),
            ('Paixão de Cristo', EXTRACT(DAY FROM easter - INTERVAL '2 day'), EXTRACT(MONTH FROM easter - INTERVAL '2 day'), CAST(currentYear AS VARCHAR(4)), '899e08e9-bc6b-4bef-be27-7a17354e583b', 1, initialDate),
            ('Carnaval', EXTRACT(DAY FROM easter - INTERVAL '47 day'), EXTRACT(MONTH FROM easter - INTERVAL '47 day'), CAST(currentYear AS VARCHAR(4)), '899e08e9-bc6b-4bef-be27-7a17354e583b', 1, initialDate),
            ('Corpus Christi', EXTRACT(DAY FROM easter + INTERVAL '60 day'), EXTRACT(MONTH FROM easter + INTERVAL '60 day'), CAST(currentYear AS VARCHAR(4)), '899e08e9-bc6b-4bef-be27-7a17354e583b', 1, initialDate);
	
        IF currentYear % 4 <> 0
            THEN
                initialDate := initialDate + INTERVAL '365 days';
            ELSE
	        initialDate := initialDate + INTERVAL '366 days';
            END IF;	

    end loop;
end$$;

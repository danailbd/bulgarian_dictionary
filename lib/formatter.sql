use rechko;

SELECT		
    word.name		
    , IF (		
        word.synonyms IS NOT NULL AND word.synonyms != ''		
        , CONCAT(REPLACE(REPLACE(word.meaning, "\r\n", "<br />"), "\n", "<br />"), "<br />Синоними: ", REPLACE(REPLACE(REPLACE(word.synonyms, "\r\n", ", "), "\n", ", "), "\r", ", "))		
        , REPLACE(REPLACE(word.meaning, "\r\n", "<br />"), "\n", "<br />")		
    ) AS `meaning`		
    , (SELECT		
			GROUP_CONCAT(derivative_form.name SEPARATOR ', ')		
		FROM		
			derivative_form		
		WHERE		
			derivative_form.base_word_id = word.id		
		) AS `inflections`
/*     INTO OUTFILE 'rechko.csv'
       FIELDS TERMINATED BY ','
       ENCLOSED BY '"'
       LINES TERMINATED BY '\n'
*/
FROM		
    word		
WHERE		
    word.meaning IS NOT NULL		
    AND word.meaning != '';


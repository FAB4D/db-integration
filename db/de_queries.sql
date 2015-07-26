SELECT count(orig.id)	 
	FROM customer orig 
	WHERE EXISTS( 
		SELECT * 
		FROM customer dup 
		WHERE orig.name=dup.name and orig.street=dup.street and dup.birthday=orig.birthday and dup.gender = orig.gender AND dup.id <> orig.id
	) AND orig.id NOT IN(
		SELECT orig.id 
		FROM customer orig 
		WHERE EXISTS( 
			SELECT * 
			FROM customer dup 
			WHERE orig.name=dup.name and orig.street=dup.street and dup.birthday=orig.birthday and dup.gender = orig.gender AND dup.id > orig.id
		) AND NOT EXISTS ( 
			SELECT * 
			FROM customer dup 
			WHERE orig.name=dup.name and orig.street=dup.street and dup.birthday=orig.birthday and dup.gender = orig.gender AND dup.id < orig.id
	)
);

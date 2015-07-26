import jellyfish
from jellyfish import *

def get_alnum_seq(seq):
    nseq = "".join(char for char in seq if char.isalnum())
    nseq = nseq.upper()
    return nseq
    
def get_matching_seq(target_seq, gt_seqs_dict):
    best_score = 10000 
    
    target_seq = ''.join(c for c in target_seq if c.isalnum())
    target_seq = target_seq.upper()

    best_matching_index = 0 
    best_matching_seq = ""
    
    for key, gt_seq in gt_seqs_dict.iteritems():
        gt_seq = ''.join(c for c in gt_seq if c.isalnum())
        gt_seq = gt_seq.upper()
        curr_score = jellyfish.damerau_levenshtein_distance(target_seq, gt_seq)

        if curr_score < best_score:
            best_score = curr_score
            best_matching_index = key 
            best_matching_seq = gt_seq

    return best_matching_index
    
 
def get_matching_mov_title(seq,gt_rows,col_name):
	seq = ''.join(c for c in seq if c.isalnum())
	seq = seq.upper()
	rows = list(gt_rows)
	first_row = rows.pop(0)
	gt_seq = first_row[col_name]
	gt_seq = ''.join(c for c in gt_seq if c.isalnum())
	gt_seq = gt_seq.upper()
	best_score = jellyfish.damerau_levenshtein_distance(seq,gt_seq)
	best_match = first_row[col_name]
	for row in rows:
		gt_seq = ''.join(c for c in row[col_name] if c.isalnum())
		gt_seq = gt_seq.upper()
		cur_score = jellyfish.damerau_levenshtein_distance(seq,gt_seq)
		if cur_score < best_score:
			best_score = cur_score
			best_match = row[col_name]
	return best_match


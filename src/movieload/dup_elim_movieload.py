import io, string, sys, os.path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import dup_elimination as de
import os

if __name__ == '__main__':
    # eliminate duplicates in movie
    de.dup_eli("movie",["title","genre"],["buy"],["mid"])
    # eliminate duplicates in customer
    de.dup_eli("customer",["name","street","birthday","gender"],["buy"],["cid"])
    

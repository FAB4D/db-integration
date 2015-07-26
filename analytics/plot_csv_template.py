import sys
import os
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

def q3a_om(base_path, csv_fn):
    filename = "".join([base_path, csv_fn])
    names = ['genre', 'gender', 'age', 'type', 'movies']
    my_data = np.recfromcsv(filename, names = ['genre', 'gender', 'age', 'type', 'movies'])

    gender = my_data['gender']
    download = get_arr_for_col_del(my_data, 'type', names, "download")
    view = get_arr_for_col_del(my_data, 'type', names, "view")
    names.pop(3)
    download_f = get_arr_for_col_del(download, 'gender', names, "F")
    download_m = get_arr_for_col_del(download, 'gender', names, "M")

    view_f = get_arr_for_col_del(view, 'gender', names, "F")
    view_m = get_arr_for_col_del(view, 'gender', names, "M")
    # view_m contains all the number of movies ordered by genres viewed by different male age groups

    plot_q3a(download_f, names, 'Movies downloaded', 'Movie distr. F')
    plot_q3a(download_m, names, 'Movies downloaded', 'Movie distr. M')
    plot_q3a(view_f, names, 'Movies viewed', 'Movie distr. F')
    plot_q3a(view_m, names, 'Movies viewed', 'Movie distr. M')

    return

def q3a_pm(base_path, csv_fn):
    filename = "".join([base_path, csv_fn])
    names = ['genre', 'gender', 'movies', 'type', 'age']
    my_data = np.recfromcsv(filename, names = ['genre', 'gender', 'movies', 'type', 'age'])
    
    vhs = get_arr_for_col_del(my_data, 'type', names, "VHS")
    dvd = get_arr_for_col_del(my_data, 'type', names, "DVD")
    bluray = get_arr_for_col_del(my_data, 'type', names, "BLURAY")

    names.pop(3)
    
    vhs_f = get_arr_for_col_del(vhs, 'gender', names, "F")
    vhs_m = get_arr_for_col_del(vhs, 'gender', names, "M")

    dvd_f = get_arr_for_col_del(dvd, 'gender', names, "F")
    dvd_m = get_arr_for_col_del(dvd, 'gender', names, "M")

    bluray_f = get_arr_for_col_del(bluray, 'gender', names, "F")
    bluray_m = get_arr_for_col_del(bluray, 'gender', names, "M")

    plot_q3a(vhs_f, names, 'VHS copies', 'Movie distr. F')
    plot_q3a(vhs_m, names, 'VHS copies', 'Movie distr. M')

    plot_q3a(dvd_f, names, 'DVD copies', 'Movie distr. F')
    plot_q3a(dvd_m, names, 'DVD copies', 'Movie distr. M')

    plot_q3a(bluray_f, names, 'Bluray copies', 'Movie distr. F')
    plot_q3a(bluray_m, names, 'Bluray copies', 'Movie distr. M')

    return

def plot_q3a(data, names, zlabel, title):
    age_arr = np.unique(data['age'])
    age_arr = age_arr.astype(int)
    genre_arr = np.unique(data['genre'])
    print genre_arr
    print data['genre']
    age_list = age_arr.tolist()

    movies = add_zero_aggregate(data, age_arr, genre_arr, age_list, names)
    print 
    plot_3D_bar_graph(age_arr, genre_arr, movies, 'Age', 'Genre', zlabel, title)

    return

def q3b(base_path, csv_fn, z_label):
    filename = "".join([base_path, csv_fn])
    names = ['genre', 'gender', 'movies', 'age']

    my_data = np.recfromcsv(filename, names = ['genre', 'gender', 'movies', 'age'])

    data_m = get_arr_for_col_del(my_data, 'gender', names, "F")
    data_f = get_arr_for_col_del(my_data, 'gender', names, "M")

    plot_q3a(data_m, names, z_label, 'Movies by Men')
    plot_q3a(data_f, names, z_label, 'Movies by Women')

    return

def q3b_download(base_path, csv_fn, z_label):
    filename = "".join([base_path, csv_fn])
    names = ['genre', 'gender', 'age', 'movies']

    my_data = np.recfromcsv(filename, names = ['genre', 'gender', 'age', 'movies'])

    data_m = get_arr_for_col_del(my_data, 'gender', names, "F")
    data_f = get_arr_for_col_del(my_data, 'gender', names, "M")

    plot_q3a(data_m, names, z_label, 'Movies by Men')
    plot_q3a(data_f, names, z_label, 'Movies by Women')

    return

# add zero values to data for z-component of bar graph
def add_zero_aggregate(base_arr, age_arr, genre_arr, age_list, names):
    # age_arr x genre_arr
    la = len(age_arr)
    lg = len(genre_arr) 
    movies = np.arange(la*lg).reshape(la,lg)
    i = 0
    # for each age augment i
    for age in age_list:
        arr_for_age = get_arr_for_col(base_arr, "age", names, age)  
        age_genres = arr_for_age['genre']
        # find matching indices in arr_for_age genre and genre_arr
        # and then restructure array

        # go over j 
        indicator = np.in1d(genre_arr, age_genres)
        j = 0 # for matrix
        # go over k - for num movies for genres in array
        k = 0
        for boolval in indicator:
            if boolval:
                movie_val = arr_for_age['movies'][k]
                movies[i,j] = int(movie_val)
                k += 1 
            else:
                movies[i,j] = 0
            j += 1 

        i += 1

    return movies.flatten('F')

def q3c_om(base_path, csv_fn):
    # sex, age, movies
    filename = "".join([base_path, csv_fn])
    names = ['gender', 'age', 'movies']

    my_data = np.recfromcsv(filename, names = ['gender', 'age', 'movies'])

    age_arr = my_data['age']
    gender_arr = my_data['gender']
    movies = my_data['movies']
    plot_3D_bar_graph(age_arr, gender_arr, movies, 'Age', 'Gender', 'Movies sold online', 'Movies by age and sex')
    return

def q3c_pm(base_path, csv_fn):
    filename = "".join([base_path, csv_fn])
    names = ['gender', 'movies', 'age']

    my_data = np.recfromcsv(filename, names = ['gender', 'movies', 'age'])

    age_arr = my_data['age']
    gender_arr = my_data['gender']
    movies = my_data['movies']
    plot_3D_bar_graph(age_arr, gender_arr, movies, 'Age', 'Gender', 'Movies sold online', 'Movies by age and sex')
    return


def plot_bar_graph(x_arr, y_arr, x_label, y_label):

    fig= plt.figure()
    ax = fig.add_subplot(2,1,1)

    ax.bar(x_arr, y_arr, facecolor='#FF0000', align='center')
    ax.set_xticks(x_arr)
    ax.setylabel(y_label)

    ax.set_xticklabels(age_list)
    fig.autofmt_xdate()

# plot 3d bar graph
def plot_3D_bar_graph(x_arr, y_arr, z_arr, x_label, y_label, z_label, plot_title):
    fig = plt.figure()
    plt.title(plot_title)
    ax = Axes3D(fig)

    lx = len(x_arr)
    ly = len(y_arr)
    xpos = np.arange(0, lx, 1)
    ypos = np.arange(0, ly, 1)
    xpos, ypos = np.meshgrid(xpos+.25, ypos+.25)
    xpos = xpos.flatten()
    ypos = ypos.flatten()
    zpos = np.zeros(lx * ly)

    dx = .5* np.ones_like(zpos)
    dy = dx.copy()
    dz = z_arr.flatten()

    #column_names = list of ages
    #column_names = unique list of genres

    ax.bar3d(xpos, ypos, zpos, dx, dy, dz, color = 'b', alpha = .5)

    plt.xticks(np.arange(.5, lx, 1), x_arr)
    plt.yticks(np.arange(.5, ly, 1), y_arr)

    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    ax.set_zlabel(z_label)
    fig.autofmt_xdate()
    plt.show()

    return

# return records where col = value 
def get_arr_for_col(data_arr, column_name, names, val):
    dt = data_arr.dtype
    rec_list = [rec for rec in data_arr if rec[column_name] == val]
    new_arr = np.asarray(rec_list)
    rec_len = len(rec_list[0])
    cols = [i for i in names if i != column_name]
    commas = ', '.join(str(col) for col in cols)
    new_arr = new_arr.astype(dt)
    return new_arr

# return records where col = value and then delete col from records
def get_arr_for_col_del(data_arr, column_name, names, val):
    dt = data_arr.dtype
    rec_list = [rec for rec in data_arr if rec[column_name] == val]
    new_arr = np.asarray(rec_list)
    rec_len = len(rec_list[0])
    cols = [i for i in names if i != column_name]
    new_arr = new_arr.astype(dt)

    new_arr = new_arr[cols]
    return new_arr
    
def main():
    # use hardcoded filenames
    wd = os.getcwd()
    base_path = "/".join([wd, "q3csv_query_dumps/"])

    #q3a_pm(base_path, 'question3a_pm.csv')
    #q3a_om(base_path, 'question3a_om.csv')
    #q3b(base_path, 'question3b_om.csv', 'Movies viewed')
    q3b_download(base_path, 'question3b_download.csv', 'Movies downloaded')
    q3b(base_path, 'question3b_sold.csv' , 'Copies sold')
    '''
    q3c_om(base_path, 'question3c_om.csv')
    q3c_pm(base_path, 'question3c_pm.csv')
    '''

    return

if __name__ == "__main__":
    main()
    '''
    if len(sys.argv) < 2:
        print "usage: csv_filename (file has to be in folder q3csv_query_dumps)"
    else:
        main(*sys.argv[1:])
    '''

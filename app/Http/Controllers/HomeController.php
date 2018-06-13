<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use DB;

use App\Post;

/**
 * Handles logic for the homepage.
 * @package App\Http\Controllers
 */
class HomeController extends Controller
{

    public function testHome()
    {
        $data['posts'] = Post::orderBy('created_at', 'desc')->get();
        return view('home', $data);
    }

    public function add()
    {
        $data = [];
        return view('add', $data);
    }

    public function addPost(Request $request)
    {
        $request->validate([
            'title' => 'required|min:5',
            'body' => 'required|min:5'
        ]);

        $post = new Post([
            'title'   => $request->title,
            'body'    => $request->body,
        ]);

        $post->user_id = 1; //using this for this test, would normally access the auth user

        $post->save();

        return 'Success';
    }
}

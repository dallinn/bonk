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
        return view('add');
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

    public function edit(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        return view('add', [ 'post' => $post ]);
    }

    public function editPost(Request $request, $id)
    {
        $request->validate([
            'title' => 'required|min:5',
            'body' => 'required|min:5'
        ]);

        $post = Post::findOrFail($id);
        $post->update($request->all());

        $post->save();

        return 'Success';
    }
}

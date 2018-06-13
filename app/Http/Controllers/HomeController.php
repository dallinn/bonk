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

        $data = [
            'title' => $request->title,
            'body'  => $request->body,
            'user_id'  => 1
        ];

        DB::table('posts')->insert($data);

        return 'Success';
    }
}

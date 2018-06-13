<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use DB;

/**
 * Handles logic for the homepage.
 * @package App\Http\Controllers
 */
class HomeController extends Controller
{

    public function testHome()
    {
        $data['posts'] = DB::table('posts')->get();
        return view('home', $data);
    }

    public function add()
    {
        $data = [];
        return view('add', $data);
    }

    public function addPost(Request $request)
    {
        $data = [
            'topic' => $request->title,
            'body'  => $request->body,
            'user'  => 1
        ];

        DB::table('posts')->insert($data);

        return 'Success';
    }


}

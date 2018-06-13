<?php

use Illuminate\Database\Seeder;

class PostsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('posts')->insert(
            [
                'id'         => 1,
                'title'      => 'First Post',
                'body'       => 'Lots of text here',
                'user_id'    => 1,
                'created_at' => '2017-09-01 05:00:00'
            ]);
        DB::table('posts')->insert(
            [
                'id'         => 2,
                'title'      => 'Second Post',
                'body'       => 'Lots of other text here',
                'user_id'    => 1,
                'created_at' => '2017-09-05 10:00:00'
            ]);
        DB::table('posts')->insert(
            [
                'id'         => 3,
                'title'      => 'Other Post',
                'body'       => 'Some text here',
                'user_id'    => 1,
                'created_at' => '2017-09-03 10:00:00'
            ]
        );
    }
}

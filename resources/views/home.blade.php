<!DOCTYPE html>
<html lang="en">
<head>
    @include('partials._head')
</head>

<body>

@include('partials._nav')

<div class="container">
    @yield('content')
    <table class="table">
        <thead>
            <th>Title</th>
            <th>Body</th>
            <th>User</th>
            <th>Posted</th>
        </thead>
    @foreach ($posts as $post)
        <tr>
            <td>{{ $post->titl }}</td>
            <td>{{ $post->body }}</td>
            <td>{{ $post->user }}</td>
            <td>{{ $post->created_at }}</td>
        </tr>
    @endforeach
    </table>


    @include('partials._footer')

</div> <!-- end of .container -->

@include('partials._javascript')

@yield('scripts')

</body>
</html>
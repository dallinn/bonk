<!DOCTYPE html>
<html lang="en">
<head>
    @include('partials._head')
</head>

<body>

@include('partials._nav')

<div class="container">
    @yield('content')
    <form id="postForm" action="/addPost" method="post">
        <input type="hidden" name="_token" value="{{ csrf_token() }}">
        <div class="form-group">
            <input placeholder="Enter title here" type="text" name= "title" class="form-control" />
        </div>
        <div class="form-group">
            <textarea name="body" class="form-control"></textarea>
        </div>
        <input type="submit" class="btn btn-default" value="Submit" />
    </form>
    @include('partials._footer')

</div> <!-- end of .container -->

@include('partials._javascript')
<script type="application/javascript">

</script>

@yield('scripts')

</body>
</html>